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

    UTF8MB4_GENERAL_CI = 45

    def handshake_response(server_handshake, capability, username:, password:, database:)
      if Gem::Version.new(server_handshake.version) < Gem::Version.new("5.6")
        raise "Unexpected server version: #{server_handshake.version}"
      end

      if (capability & Constants::CapabilityFlags::CLIENT_DEPRECATE_EOF) == 0
        raise "This client only supports CLIENT_DEPRECATE_EOF"
      end

      if database
        capability = capability | Constants::CapabilityFlags::CLIENT_CONNECT_WITH_DB
      end

      bytes = +"".encode('ASCII')
      bytes << [capability].pack("L<")
      bytes << [0, 0, 0, 1].pack("c*") # max packet size
      collation = UTF8MB4_GENERAL_CI
      bytes << [collation].pack("c")
      23.times do
        bytes << "\x00"
      end

      bytes << username.encode('ASCII')
      bytes << "\x00"

      nonce = ""
      if password
        scramble = server_handshake.scramble_1 + server_handshake.scramble_2
        # SHA1( password ) XOR SHA1( "20-bytes random data from server" <concat> SHA1( SHA1( password ) ) )
        nonce = xor(sha1(password), sha1(scramble + sha1(sha1(password))))
      end

      if (capability & Constants::CapabilityFlags::CLIENT_PLUGIN_AUTH_LENENC_CLIENT_DATA) != 0
        bytes << write_lenenc_str(nonce)
      elsif capability & Constants::CapabilityFlags::CLIENT_SECURE_CONNECTION
        # data.push(scramble.len() as u8);
        # data.extend_from_slice(scramble);
        raise NotImplementedError
      else
        bytes << scramble.encode("ASCII")
        bytes << "\x00"
      end

      if (capability & Constants::CapabilityFlags::CLIENT_CONNECT_WITH_DB) != 0
        bytes << database.encode("ASCII")
        bytes << "\x00"
      end

      if (capability & Constants::CapabilityFlags::CLIENT_PLUGIN_AUTH) != 0
        bytes << "mysql_native_password".encode('ASCII')
        bytes << "\x00"
      end

      if (capability & Constants::CapabilityFlags::CLIENT_CONNECT_ATTRS) != 0
        # empty conn attributes
        bytes << "\x00"

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
      end

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
