module MysqlRb
  module PacketHelpers
    private

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

  module HandshakeUtils
    extend self

    def parse_handshake(line)
      hs = HandshakePacket.new

      line = StringIO.new(line)

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
end

