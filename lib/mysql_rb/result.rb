module MysqlRb
  class Result
    include PacketHelpers

    WAIT_RESULT_SET_HEADER = 1
    WAIT_RESULT_SET_FIELDS = 2
    WAIT_RESULT_SET_DATA = 3
    WAIT_RESULT_SET_DONE = 4

    def initialize(packets)
      @packets = packets
      @fields = []
      @results = []
      @state = WAIT_RESULT_SET_HEADER

      materialize
    end

    def fields
      unless @state >= WAIT_RESULT_SET_DATA
        raise "fields not read yet"
      end
      @fields
    end

    # def results
    #   # unless @state == WAIT_RESULT_SET_DONE
    #   call
    #   # end
    # end

    def self.from(packets)
      new(packets)
    end

    attr_reader :results

    private

    def materialize
      @packets.each do |packet_obj|
        packet = packet_obj.data.pack("c*")

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
            # break if fields_only
          end
        when WAIT_RESULT_SET_DATA
          process_row(packet)
        when WAIT_RESULT_SET_DONE
          break
        else
          raise "WTF is the state?"
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
      row.fields = @fields

      @fields.each do |column|
        value, packet = get_lenenc_str(packet)
        # value, packet = get_length_binary(packet)
        row.data << value
      end

      row.finalize

      @results << row
    end
  end

end
