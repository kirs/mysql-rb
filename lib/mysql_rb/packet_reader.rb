module MysqlRb
  class PacketReader
    class ReadBuffer
      BUFFER_SIZE = 1024

      def initialize(io, size: BUFFER_SIZE)
        @io = io
        @buffer = ""
        @buffer_size = size
      end

      def read_bytes(size)
        if @io.respond_to?(:recv)
          @io.recv(size)
        else
          @io.read(size)
        end
      end

      def read(size)
        until @buffer.size >= size
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

    def read_packet
      head = @buf.read(4)
      len = head[0..2].unpack1("s<")
      seq = head[3].unpack1("c")

      data = @buf.read(len)
      MysqlRb::Packet.new.tap do |pack|
        pack.len = len
        pack.seq = seq
        pack.data = data
      end
    end

    def read
      packets = []
      loop do
        packet = read_packet
        packets << packet
        break if eof_packet?(packet)
      end
      packets
    end

    def eof_packet?(packet)
      code = packet.data.bytes.first # TODO: optimize!
      code == 0xfe || code == 0x00 || code == 0xff
    end
  end
end
