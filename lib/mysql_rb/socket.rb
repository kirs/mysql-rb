# frozen-string-literal: true
module MysqlRb
  class Socket
    OK_PACKET = "\x00"

    COM_QUERY = 0x03
    COM_PING = 0x0e

    DEFAULT_CAPABILITY = 0x81bea205

    UTF8MB4_GENERAL_CI = 45
    DEFAULT_COLLATION = UTF8MB4_GENERAL_CI

    def initialize(addr, port)
      @sock = TCPSocket.new(addr, port)
      @packet_reader = MysqlRb::PacketReader.new(@sock)
    rescue => error
      raise ConnectionError.new(error)
    end

    def handshake(username:, password:, database:, flags: [])
      if username.empty?
        raise ArgumentError, "username missing"
      end

      packet = @packet_reader.read_packet

      server_hs = HandshakeUtils.parse_handshake(packet.data)

      capability = DEFAULT_CAPABILITY
      # TODO: support flags

      resp = HandshakeUtils.handshake_response(
        server_hs,
        capability,
        username: username,
        password: password,
        database: database,
        collation: DEFAULT_COLLATION
      )
      @sock.write(Packet.wrap(resp, 1))

      ok_packet = @sock.recv(1024)
      if ok_packet[4] != OK_PACKET
        raise MysqlRb::HandshakeError, "unexpected handshake packet: #{ok_packet}"
      end
    rescue => error
      raise MysqlRb::HandshakeError.new(error)
    end

    def query_command(query)
      [COM_QUERY, query].pack('Ca*')
    end

    def write_packet(command)
      @sock.write(Packet.wrap(command, 0))
    end

    def ping
      write_packet([COM_PING].pack('C'))
      _packet = @packet_reader.read_packet
    end

    def read_packets
      @packet_reader.read
    end

    def close
      @sock.close
    end
  end
end
