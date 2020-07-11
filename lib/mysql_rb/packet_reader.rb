module MysqlRb
  class PacketReader
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

    def initialize(io)
      @buf = ReadBuffer.new(io)
    end

    def read
      packets = []
      loop do
        h = @buf.read(4)
        packet_len = h[0..2].pack("c*").unpack1("s<")
        seq = h[3]

        # puts "<server packet> len: #{packet_len}, seq: #{seq}"
        data = @buf.read(packet_len)
        packets << MysqlRb::Packet.new.tap do |pack|
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
  end
end
