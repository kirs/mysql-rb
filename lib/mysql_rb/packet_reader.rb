module MysqlRb
  class PacketReader
    class ReadBuffer
      BUFFER_SIZE = 1024

      def initialize(io, size: @buffer_size)
        @io = io
        @buffer = ""
        @buffer_size = BUFFER_SIZE
      end

      def read_bytes(size)
        if @io.respond_to?(:recv)
          @io.recv(size)
        else
          @io.read(size)
        end
      end
      def read(size)
        puts "left in buffer: #{@buffer.size}, requesing: #{size}"
        # require'byebug';byebug
        if @buffer.size < size
          @buffer += read_bytes(@buffer_size)
        end

        t = @buffer[0..(size-1)]
        @buffer = @buffer[size..]
        t
      end
    end

    def initialize(io)
      @buf = ReadBuffer.new(io)
    end

    # TODO
    def read_packet
    end

    def read
      packets = []
      loop do
        h = @buf.read(4)
        packet_len = h[0..2].unpack1("s<")
        seq = h[3].unpack1("c")

        data = @buf.read(packet_len)
        packets << MysqlRb::Packet.new.tap do |pack|
          pack.len = packet_len
          pack.seq = seq
          pack.data = data
        end

        code = data.bytes.first # TODO: optimize!
        if code == 0xfe || code == 0x00 || code == 0xff
          # puts "eof detected!"
          break
        end
      end
      packets
    end
  end
end
