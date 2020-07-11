module MysqlRb
  class Socket
    def initialize(addr, port)
      @sock = TCPSocket.new(addr, port)
    rescue => error
      raise ConnectionError.new(error)
    end

    def handshake
      line_raw = @sock.recv(1024)
      line = StringIO.new(line_raw)

      packetlen = line.read(3).unpack1('s<') # 3 bytes, s< is 16-bit signed, little endian
      packetnum = line.getc.to_i
      puts "<packet> len: #{packetlen}, num: #{packetnum}"

      h = HandshakeUtils.parse_handshake(line)
      puts h.inspect

      hr = HandshakeUtils.handshake_response
      @sock.write(Packet.wrap(hr, 1))
      # TODO: @server_status = hr.server_status
      # @capabilities = ...

      ok_packet = @sock.recv(1024)
      if ok_packet[4] == "\x00"
        puts "connection phase: success"
      else
        raise MysqlRs::HandshakeError, "unexpected handshake packet: #{ok_packet}"
      end
    rescue => error
      raise MysqlRs::HandshakeError.new(error)
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
      MysqlRb::PacketReader.new(@sock).read
    end

    def close
      @sock.close
    end
  end
end
