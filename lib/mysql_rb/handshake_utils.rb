# frozen-string-literal: true
require 'digest'
module MysqlRb
  module HandshakeUtils
    extend self

    def parse_handshake(line)
      hs = HandshakePacket.new

      line = StringIO.new(line)

      hs.protocol = line.getc.unpack1("c")
      hs.version = read_str_null(line)

      hs.connid = line.read(4).unpack1('V')

      hs.scramble_1 = line.read(8)#.unpack("c*")

      line.pos = line.pos+1

      cap = line.read(2).unpack1("S<")
      hs.encoding = line.getc.unpack1("C")
      hs.server_status = line.read(2).unpack1("S<")

      extcap = line.read(2).unpack1("S<")

      hs.capability = ((extcap << 16) | cap)
      if hs.capability & MysqlRb::Constants::CapabilityFlags::CLIENT_PLUGIN_AUTH

      end

      _authlen = line.getc.unpack1("C")
      line.pos = line.pos+10

      hs.scramble_2 = read_str_null(line)
      hs.auth_plugin = read_str_null(line)
      hs
    end

    def read_str_null(line)
      value = +""
      loop do
        c = line.getc
        break if c == "\x00"
        value << c
      end
      value
    end

    extend PacketHelpers

    def handshake_response(server_handshake, username:, password:)
      collation = 45 # UTF8MB4_GENERAL_CI
      #  let collation = if server_version >= (5, 5, 3) {
      #      UTF8MB4_GENERAL_CI
      #  } else {
      #      UTF8_GENERAL_CI
      #  };

      #  if let Some(_) = db_name {
      #      client_flags = client_flags | CapabilityFlags::CLIENT_CONNECT_WITH_DB;
      #  }

      bytes = +"".encode('ASCII')

      client_flags = 0x81bea205
      bytes << [client_flags].pack("L<")
      bytes << [0, 0, 0, 1].pack("c*") # max packet size
      bytes << [collation].pack("c")
      23.times do
        bytes << "\x00"
      end

      bytes << username.encode('ASCII')
      bytes << "\x00"

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

      # require'byebug';byebug
      scramble = server_handshake.scramble_1 + server_handshake.scramble_2

      # SHA1( password ) XOR SHA1( "20-bytes random data from server" <concat> SHA1( SHA1( password ) ) )

      if password
        nonce = xor(sha1(password), sha1(scramble + sha1(sha1(password))))
        bytes << length_binary(nonce)
      else
        bytes << "\x00"
      end
      # bytes << "\x00"
      # bytes

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

      bytes << "mysql_native_password".encode('ASCII')
      bytes << "\x00"

      # empty conn attributes
      bytes << "\x00"

      # bytes << [
      #   # 0x05, 0xa2, 0xbe, 0x81, # client capabilities
      #   # 0x00, 0x00, 0x00, 0x01, # max packet
      #   # 0x2d, # charset
      #   # 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      #   # 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, # reserved
      #   # 0x72, 0x6f, 0x6f, 0x74, 0x00, # username=root
      #   0x00, # blank scramble
      #   0x6d, 0x79, 0x73, 0x71, 0x6c, 0x5f, 0x6e, 0x61, 0x74, 0x69, 0x76, 0x65, 0x5f, 0x70,
      #   0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64, 0x00, # mysql_native_password
      #   0x00,
      # ].pack("c*")
      bytes
    end

    def sha1(value)
      Digest::SHA1.digest(value)
    end

    def xor(one, other)
      b1 = one.unpack("c*")
      b2 = other.unpack("c*")
      longest = [b1.length,b2.length].max
      b1 = [0]*(longest-b1.length) + b1
      b2 = [0]*(longest-b2.length) + b2
      b1.zip(b2).map{ |a,b| a^b }.pack("c*")
    end
  end
end
