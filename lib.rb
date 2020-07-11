
class HandshakePacket
  attr_accessor :protocol, :version, :connid, :cap, :extcap, :server_status, :encoding
end

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

  bytes = "".encode("ASCII")

  client_flags = 0x81bea205
  bytes << [client_flags].pack("L<")
  # byebug
  #  let mut data = Vec::with_capacity(1024);
  #  data.write_u32::<LE>(client_flags.bits()).unwrap();
  bytes << [0, 0, 0, 1].pack("c*")
  #  data.extend_from_slice(&[0x00, 0x00, 0x00, 0x01]);
  #  data.push(collation as u8);
  bytes << [collation].pack("c")
  23.times do
    bytes << "\x00"
  end


  bytes << "root".encode('ASCII')
  # "root".chars.each do |c|
  #   bytes << [c].pack("A")
  # end
  bytes << "\x00"

  # byebug
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

def wrap_packet(bytes, n)
  packet = "".encode("ASCII")
  packet << [bytes.size].pack("L<")[0..2]
  packet << [n].pack("C")
  packet << bytes
  packet
end

class ReadBuffer
  def initialize(io)
    @io = io
    @buffer = []
  end

  def read_bytes(size)
    if @io.respond_to?(:recv)
      @io.recv(size).bytes
    else
      @io.read(size).bytes
    end
  end

  def read(size)
    require'byebug';byebug
    if @buffer.size < size
      @buffer += read_bytes(size)
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
    puts "reading header..."
    h = buf.read(4)
    packet_len = h[0..2].pack("c*").unpack1("s<")
    seq = h[3]

    puts "<server packet> len: #{packet_len}, seq: #{seq}"
    data = buf.read(packet_len)
    packets << Packet.new.tap do |pack|
      pack.len = packet_len
      pack.seq = seq
      pack.data = data
    end

    if data[0] == 0xfe || data[0] == 0x00
      puts "eof detected!"
      break
    end
  end
  packets
end
