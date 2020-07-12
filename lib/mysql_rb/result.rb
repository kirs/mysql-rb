module MysqlRb
  class Result
    include PacketHelpers
    include Enumerable

    WAIT_RESULT_SET_HEADER = 1
    WAIT_RESULT_SET_FIELDS = 2
    WAIT_RESULT_SET_DATA = 3
    WAIT_RESULT_SET_DONE = 4

    def initialize(packets)
      @packets = packets
      @fields = []
      @results = []
      @state = WAIT_RESULT_SET_HEADER

      materialize(false)
    end

    def fields
      unless @state >= WAIT_RESULT_SET_DATA
        raise "fields not read yet"
      end
      @fields
    end

    def each(as: :hash, symbolize_keys: false, &block)
      case as
      when :array
        results.lazy.map(&:data).each(&block)
      when :hash
        results.lazy.map { |r| r.as_hash(@fields, symbolize_keys: symbolize_keys) }.each(&block)
      else
        raise ArgumentError, "unknown :as value: #{as}. Supported values: :hash, :array"
      end
    end

    def self.from(packets)
      new(packets)
    end

    def server_status
      materialize(true)
      @server_status
    end

    def warning_count
      materialize(true)
      @warning_count
    end

    private

    # TODO: rename to rows?
    def results
      materialize(true)
      @results
    end

    def materialize(full)
      return if @state == WAIT_RESULT_SET_DONE
      loop do
        packet_obj = @packets.shift
        packet = packet_obj.data

        header = packet[0].unpack1("C")
        case header
        when 0xff
          error_info = packet.unpack('CvCa5Z*')

          errno = error_info[1]
          sqlstate = error_info[3]
          msg = error_info[4]

          raise "process_command(): error: #{errno}, sqlstate: #{sqlstate}, msg: #{msg}"
        when 0xfe, 0x00
          # An OK packet is sent from the server to the client
          # to signal successful completion of a command.
          # As of MySQL 5.7.5, OK packes are also used to indicate EOF,
          # and EOF packets are deprecated.

          @warning_count = packet[1..2].unpack1("S<")
          @server_status = packet[3..4].unpack1("S<")

          @state = WAIT_RESULT_SET_DONE
          break
        end

        case @state
        when WAIT_RESULT_SET_HEADER
          @fields_count = get_length_binary_nonmut(packet)
          @state = WAIT_RESULT_SET_FIELDS
        when WAIT_RESULT_SET_FIELDS
          parse_col_def_packet(packet)
          if @fields.size == @fields_count
            @state = WAIT_RESULT_SET_DATA
            break if !full
          end
        when WAIT_RESULT_SET_DATA
          process_row(packet)
        when WAIT_RESULT_SET_DONE
          break
        else
          raise "Unknown state: #{@state}"
        end
      end
    end

    def parse_col_def_packet(packet)
      column = Column.new

      catalog, packet = get_lenenc_str(packet)
      db, packet = get_lenenc_str(packet)
      table, packet = get_lenenc_str(packet)
      _org_table, packet = get_lenenc_str(packet)
      name, packet = get_lenenc_str(packet)
      org_name, packet = get_lenenc_str(packet)
      other_info = packet.unpack('CvVCvCC2a*')

      charsetnr = other_info[1]
      length = other_info[2]
      type = other_info[3]
      flags = other_info[4]
      decimal = other_info[5]

      column.catalog = catalog
      column.db = db
      column.table = table
      column.org_table = table
      column.name = name
      column.org_name = org_name
      column.charsetnr = charsetnr
      column.length = length
      column.type = type
      column.flags = flags
      column.decimal = decimal

      @fields << column
    end

    def process_row(packet)
      row = Row.new

      @fields.each do |column|
        value, packet = get_lenenc_str(packet)
        row.data << value
      end

      @results << row
    end
  end
end
