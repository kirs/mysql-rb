require 'socket'
require 'logger'

# Credits: https://github.com/chrismoos/async-mysql
class Row
  attr_accessor :fields, :data, :attributes

  def initialize
    self.data = []
    self.attributes = {}
  end

  def finalize
    @fields.length.times do |x|
      self.attributes[@fields[x].org_name] = @data[x]
    end
  end

  def to_s
    "#<Row attributes=#{attributes}>"
  end

  def method_missing(symbol, *args)
    if self.attributes.has_key? symbol.to_s
      return self.attributes[symbol.to_s]
    else
      super(symbol, args)
    end
  end
end

FIELD_TYPES = {
  0x00 => :decimal,
  0x01 => :tiny,
  0x02 => :short,
  0x03 => :long,
  0x04 => :float,
  0x05 => :double,
  0x06 => :null,
  0x07 => :timestamp,
  0x08 => :longlong,
  0x09 => :int24,
  0x0a => :date,
  0x0b => :time,
  0x0c => :datetime,
  0x0d => :year,
  0x0e => :newdate,
  0x0f => :varchar,
  0x10 => :bit,
  0xf6 => :newdecimal,
  0xf7 => :enum,
  0xf8 => :set,
  0xf9 => :tiny_blob,
  0xfa => :medium_blob,
  0xfb => :long_blob,
  0xfc => :blob,
  0xfd => :var_string,
  0xfe => :string,
  0xff => :geometry
}

# Credits: https://github.com/chrismoos/async-mysql
class Column
  attr_accessor :catalog, :db, :table, :org_table, :name, :org_name, :charsetnr, :length, :type, :flags, :decimal, :default

  def type_name
    raise Exception.new("Unknown field type: #{self.type}") if not FIELD_TYPES.has_key? self.type
    return FIELD_TYPES[self.type]
  end

  def to_s
    "#<Column column=#{self.org_name}, type=#{type_name}>"
  end
end

class HandshakePacket
  attr_accessor :protocol, :version, :connid, :cap, :extcap, :server_status, :encoding
end

module PacketHelpers
  def length_binary(str)
    return [str.length, str].pack("Ca*") if str.length <= 250
    return [str.length, str].pack("va*") if str.length <= 32767
    return [str.length, str].pack("Va*") if str.length <= 2147483647
    return [str.length, str].pack("Qa*")
  end

  def get_length_binary_nonmut(data)
    if data[0].unpack1("c") == 252
      b, length = data.unpack('Cv')
      offset = 2
    elsif data[0].unpack1("c") == 253
      b, length = data.unpack('CV')
      offset = 4
    elsif data[0].unpack1("c") == 254
      b, length = data.unpack('CQ')
      offset = 8
    else
      return data[0].unpack1("c")
    end
    value = data[offset+1..(length + offset)]
  end

  def get_lenenc_str(packet)
    len, packet = get_length_binary(packet)
    if len == 0
      ["", packet]
    else
      [packet[0..len-1], packet[len..]]
    end
  end

  def get_length_binary(data)
    raise Exception.new("Unable to parse length binary: no data") if data.nil? or data.empty?

    if data[0].unpack1("c") == 252
      _b, length = data.unpack('Cv')
      offset = 2
    elsif data[0].unpack1("c") == 253
      _b, length = data.unpack('CV')
      offset = 4
    elsif data[0].unpack1("c") == 254
      _b, length = data.unpack('CQ')
      offset = 8
    else
      return [data[0].unpack1("c"), data[1..]]
    end

    if data[0] == 251
      #raise Exception.new("unexpected NULL column value, only expected in row data packet") if @substate != SubState::WAIT_RESULT_SET_DATA
      return [nil, data.slice(1, data.length - 1)]
    else
      raise Exception.new("Unable to parse length binary: expected: #{length}, got: #{data.length - 1}") if (data.length - 1) < length
      sliced = data.slice(length + offset + 1, data.length - length - 1)
      value = data[offset+1..(length + offset)]
      return [value, sliced]
    end
  end
end

def wrap_packet(bytes, n)
  packet = "".encode("ASCII")
  packet << [bytes.size].pack("L<")[0..2]
  packet << [n].pack("C")
  packet << bytes
  packet
end

class ReadBuffer
  BUFFER_SIZE = 1024

  def initialize(io, size: @buffer_size)
    @io = io
    @buffer = []
    @buffer_size = BUFFER_SIZE
  end

  def read_bytes(size)
    if @io.respond_to?(:recv)
      @io.recv(size).bytes
    else
      @io.read(size).bytes
    end
  end
  def read(size)
    if @buffer.size < size
      @buffer += read_bytes(@buffer_size)
    end

    @buffer.shift(size)
  end
end

class Packet
  attr_accessor :len, :seq, :data
end

def read_packets(io)
  buf = ReadBuffer.new(io)
  packets = []
  loop do
    h = buf.read(4)
    packet_len = h[0..2].pack("c*").unpack1("s<")
    seq = h[3]

    # puts "<server packet> len: #{packet_len}, seq: #{seq}"
    data = buf.read(packet_len)
    packets << Packet.new.tap do |pack|
      pack.len = packet_len
      pack.seq = seq
      pack.data = data
    end

    if data[0] == 0xfe || data[0] == 0x00 || data[0] == 0xff
      # puts "eof detected!"
      break
    end
  end
  packets
end

COM_QUERY = 3
def query_command(query)
  [COM_QUERY, query].pack('Ca*')
end

class Result
  include PacketHelpers

  WAIT_RESULT_SET_HEADER = 1
  WAIT_RESULT_SET_FIELDS = 2
  WAIT_RESULT_SET_DATA = 3
  WAIT_RESULT_SET_DONE = 4

  def initialize(packets)
    @packets = packets
    @fields = []
    @results = []
    @state = WAIT_RESULT_SET_HEADER

    materialize
  end

  def fields
    unless @state >= WAIT_RESULT_SET_DATA
      raise "fields not read yet"
    end
    @fields
  end

  # def results
  #   # unless @state == WAIT_RESULT_SET_DONE
  #   call
  #   # end
  # end

  def self.from(packets)
    new(packets)
  end

  attr_reader :results

  private

  def materialize
    @packets.each do |packet_obj|
      packet = packet_obj.data.pack("c*")

      header = packet[0].unpack1("C")
      case header
      when 0xff
        error_info = packet.unpack('CvCa5Z*')

        errno = error_info[1]
        sqlstate = error_info[3]
        msg = error_info[4]

        raise "process_command(): error: #{errno}, sqlstate: #{sqlstate}, msg: #{msg}"
      when 0xfe, 0x00
        # An OK packet is sent from the server to the client
        # to signal successful completion of a command.
        # As of MySQL 5.7.5, OK packes are also used to indicate EOF,
        # and EOF packets are deprecated.

        @state = WAIT_RESULT_SET_DONE
        break
      end

      case @state
      when WAIT_RESULT_SET_HEADER
        @fields_count = get_length_binary_nonmut(packet)
        @state = WAIT_RESULT_SET_FIELDS
      when WAIT_RESULT_SET_FIELDS
        parse_col_def_packet(packet)
        if @fields.size == @fields_count
          @state = WAIT_RESULT_SET_DATA
          # break if fields_only
        end
      when WAIT_RESULT_SET_DATA
        process_row(packet)
      when WAIT_RESULT_SET_DONE
        break
      else
        raise "WTF is the state?"
      end
    end
  end

  def parse_col_def_packet(packet)
    column = Column.new

    catalog, packet = get_lenenc_str(packet)
    db, packet = get_lenenc_str(packet)
    table, packet = get_lenenc_str(packet)
    _org_table, packet = get_lenenc_str(packet)
    name, packet = get_lenenc_str(packet)
    org_name, packet = get_lenenc_str(packet)
    other_info = packet.unpack('CvVCvCC2a*')

    charsetnr = other_info[1]
    length = other_info[2]
    type = other_info[3]
    flags = other_info[4]
    decimal = other_info[5]

    column.catalog = catalog
    column.db = db
    column.table = table
    column.org_table = table
    column.name = name
    column.org_name = org_name
    column.charsetnr = charsetnr
    column.length = length
    column.type = type
    column.flags = flags
    column.decimal = decimal

    @fields << column
  end

  def process_row(packet)
    row = Row.new
    row.fields = @fields

    @fields.each do |column|
      value, packet = get_lenenc_str(packet)
      # value, packet = get_length_binary(packet)
      row.data << value
    end

    row.finalize

    @results << row
  end
end

def escape(query)
end

class Client
  DEFAULT_OPTIONS = {
    host: 'localhost',
    port: 3306
  }

  def initialize(options)
    @connect_options = DEFAULT_OPTIONS.merge(options)
  end

  def connect
    @sock = TCPSocket.new(@connect_options.fetch(:host), @connect_options.fetch(:port))
    handshake(@sock)
  rescue => error
    raise ConnectionError.new(error)
  end

  def handshake(sock)
    line_raw = @sock.recv(1024)
    line = StringIO.new(line_raw)

    packetlen = line.read(3).unpack1('s<') # 3 bytes, s< is 16-bit signed, little endian
    packetnum = line.getc.to_i
    puts "<packet> len: #{packetlen}, num: #{packetnum}"

    h = HandshakeUtils.parse_handshake(line)
    puts h.inspect

    hr = HandshakeUtils.handshake_response
    @sock.write(wrap_packet(hr, 1))
    # TODO: @server_status = hr.server_status
    # @capabilities = ...

    ok_packet = @sock.recv(1024)
    if ok_packet[4] == "\x00"
      puts "connection phase: success"
    else
      raise HandshakeError, "unexpected handshake packet: #{ok_packet}"
    end
  end

  class ConnectionError < StandardError;end
  class HandshakeError < ConnectionError;end

  def connected?
    !!@sock
  end

  def disconnect
    @sock.close
    @sock = nil
  end

  def query(sql)
    assert_connected

    @sock.write(wrap_packet(query_command(sql), 0))

    packets = read_packets(@sock)

    Result.from(packets)
  end

  def ping
    raise NotImplementedError
  end

  def assert_connected
    connect unless connected?
  end
end

module HandshakeUtils
  extend self

  def parse_handshake(line)
    hs = HandshakePacket.new

    hs.protocol = line.getc.unpack1("c")
    version = ""

    loop do
      c = line.getc
      break if c == "\x00"
      version << c
    end
    hs.version = version

    hs.connid = line.read(4).unpack1('V')
    line.read(8)

    line.pos = line.pos+1

    hs.cap = line.read(2).unpack1("S<")
    hs.encoding = line.getc.unpack1("C")
    hs.server_status = line.read(2).unpack1("S<")

    hs.extcap = line.read(2).unpack1("S<")
    # hs.authlen = line.getc.unpack1("C")

    line.pos = line.pos+10
    hs
  end

  def handshake_response
    # let scramble = scramble_buf.as_ref().map(|x| x.as_ref()).unwrap_or(&[]);

    collation = 45 # UTF8MB4_GENERAL_CI
    #  let collation = if server_version >= (5, 5, 3) {
    #      UTF8MB4_GENERAL_CI
    #  } else {
    #      UTF8_GENERAL_CI
    #  };

    #  if let Some(_) = db_name {
    #      client_flags = client_flags | CapabilityFlags::CLIENT_CONNECT_WITH_DB;
    #  }

    bytes = ""

    client_flags = 0x81bea205
    bytes << [client_flags].pack("L<")
    bytes << [0, 0, 0, 1].pack("c*")
    bytes << [collation].pack("c")
    23.times do
      bytes << "\x00"
    end

    bytes << "root".encode('ASCII')
    bytes << "\x00"

    #  data.resize(data.len() + 23, 0);
    #  data.extend_from_slice(user.unwrap_or("").as_bytes());
    #  data.push(0);

    #  if client_flags.contains(CapabilityFlags::CLIENT_PLUGIN_AUTH_LENENC_CLIENT_DATA) {
    #      data.write_lenenc_int(scramble.len() as u64).unwrap();
    #      data.extend_from_slice(scramble);
    #  } else if client_flags.contains(CapabilityFlags::CLIENT_SECURE_CONNECTION) {
    #      data.push(scramble.len() as u8);
    #      data.extend_from_slice(scramble);
    #  } else {
    #      data.extend_from_slice(scramble);
    #      data.push(0);
    #  }
    # no auth
    bytes << "\x00"
    bytes

    #  if client_flags.contains(CapabilityFlags::CLIENT_CONNECT_WITH_DB) {
    #      let database = db_name.unwrap_or("");
    #      data.extend_from_slice(database.as_bytes());
    #      data.push(0);
    #  }

    #  if client_flags.contains(CapabilityFlags::CLIENT_PLUGIN_AUTH) {
    #      data.extend_from_slice(auth_plugin.as_bytes());
    #      data.push(0);
    #  }
    #  if client_flags.contains(CapabilityFlags::CLIENT_CONNECT_ATTRS) {
    #      let len = connect_attributes
    #          .iter()
    #          .map(|(k, v)| lenenc_str_len(k) + lenenc_str_len(v))
    #          .sum::<usize>();
    #      data.write_lenenc_int(len as u64).expect("out of memory");

    #      for (name, value) in connect_attributes {
    #          data.write_lenenc_str(name.as_bytes())
    #              .expect("out of memory");
    #          data.write_lenenc_str(value.as_bytes())
    #              .expect("out of memory");
    #      }
    #  }

    #  HandshakeResponse { data }
    [
      0x05, 0xa2, 0xbe, 0x81, # client capabilities
      0x00, 0x00, 0x00, 0x01, # max packet
      0x2d, # charset
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, # reserved
      0x72, 0x6f, 0x6f, 0x74, 0x00, # username=root
      0x00, # blank scramble
      0x6d, 0x79, 0x73, 0x71, 0x6c, 0x5f, 0x6e, 0x61, 0x74, 0x69, 0x76, 0x65, 0x5f, 0x70,
      0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64, 0x00, # mysql_native_password
      0x00,
    ].pack("c*")
  end

end
