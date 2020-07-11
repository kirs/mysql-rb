require 'socket'
require 'logger'

module MysqlRb
  class Client
    DEFAULT_OPTIONS = {
      host: 'localhost',
      port: 3306
    }

    def initialize(options)
      @connect_options = DEFAULT_OPTIONS.merge(options)
    end

    def connect
      if connected?
        raise AlreadyConnectedError
      end

      begin
        @sock = TCPSocket.new(@connect_options.fetch(:host), @connect_options.fetch(:port))
        handshake(@sock)
      rescue => error
        raise ConnectionError.new(error)
      end
    end

    class Error < StandardError;end
    class ConnectionError < Error;end
    class HandshakeError < ConnectionError;end
    class AlreadyConnectedError < Error;end

    def connected?
      !!@sock
    end

    def disconnect
      @sock.close
      @sock = nil
    end

    def query(sql)
      assert_connected

      @sock.write(Packet.wrap(query_command(sql), 0))

      packets = MysqlRb::PacketReader.new(@sock).read

      Result.from(packets)
    end

    def ping
      raise NotImplementedError
    end

    def escape(query)
    end

    private

    def assert_connected
      connect unless connected?
    end

    # [0e] COM_PING
    COM_QUERY = 3
    def query_command(query)
      [COM_QUERY, query].pack('Ca*')
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
      @sock.write(Packet.wrap(hr, 1))
      # TODO: @server_status = hr.server_status
      # @capabilities = ...

      ok_packet = @sock.recv(1024)
      if ok_packet[4] == "\x00"
        puts "connection phase: success"
      else
        raise HandshakeError, "unexpected handshake packet: #{ok_packet}"
      end
    end


  end
end

