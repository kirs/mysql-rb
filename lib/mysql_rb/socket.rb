# frozen-string-literal: true
module MysqlRb
  class Socket
    def initialize(addr, port)
      @sock = TCPSocket.new(addr, port)
      @packet_reader = MysqlRb::PacketReader.new(@sock)
    rescue => error
      raise ConnectionError.new(error)
    end

    def read_hs_packet
      line = @sock.recv(1024)

      len, seq = line[0..3].unpack('s<c')
      puts "<packet> len: #{len}, num: #{seq}"

      packet = MysqlRb::Packet.new
      packet.len = len
      packet.seq = seq
      packet.data = line[3..]
      packet
    end

    def handshake(username:, password:)
      packet = @packet_reader.read_packet

      server_hs = HandshakeUtils.parse_handshake(packet.data)
      resp = HandshakeUtils.handshake_response(server_hs, username: username, password: password)
      @sock.write(Packet.wrap(resp, 1))
      # TODO: @server_status = hr.server_status
      # @capabilities = ...

      ok_packet = @sock.recv(1024)
      if ok_packet[4] == "\x00"
        puts "connection phase: success"
      else
        raise MysqlRb::HandshakeError, "unexpected handshake packet: #{ok_packet}"
      end
    rescue => error
      raise MysqlRb::HandshakeError.new(error)
    end

    # [0e] COM_PING
    COM_QUERY = 3
    def query_command(query)
      [COM_QUERY, query].pack('Ca*')
    end

    def write_packet(command)
      @sock.write(Packet.wrap(command, 0))
    end

    def read_packets
      @packet_reader.read
    end

    def close
      @sock.close
    end
  end
end
