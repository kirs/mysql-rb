module MysqlRb
  module PacketHelpers
    private

    def write_lenenc_str(str)
      return [str.length, str].pack("Ca*") if str.length <= 250
      return [str.length, str].pack("va*") if str.length <= 32767
      return [str.length, str].pack("Va*") if str.length <= 2147483647
      return [str.length, str].pack("Qa*")
    end

    def get_length_binary_nonmut(data)
      if data[0].unpack1("C") == 252
        _b, length = data.unpack('Cv')
        offset = 2
      elsif data[0].unpack1("C") == 253
        _b, length = data.unpack('CV')
        offset = 4
      elsif data[0].unpack1("C") == 254
        _b, length = data.unpack('CQ')
        offset = 8
      else
        return data[0].unpack1("C")
      end
      data[offset+1..(length + offset)]
    end

    def get_lenenc_str(data)
      if data.nil? or data.empty?
        raise StandardError.new("Unable to parse length binary: no data")
      end

      if data[0].unpack1("C") == 252
        _b, length = data.unpack('Cv')
        offset = 2
      elsif data[0].unpack1("C") == 253
        _b, length = data.unpack('CV')
        offset = 4
      elsif data[0].unpack1("C") == 254
        _b, length = data.unpack('CQ')
        offset = 8
      else
        len = data[0].unpack1("C")
        if len == 0
          return ["", data[1..]]
        else
          return [data[1..len], data[(len+1)..]]
        end
      end

      if data[0].unpack1("C") == 251
        #raise Exception.new("unexpected NULL column value, only expected in row data packet") if @substate != SubState::WAIT_RESULT_SET_DATA
        return [nil, data.slice(1, data.length - 1)]
      else
        raise StandardError.new("Unable to parse length binary: expected: #{length}, got: #{data.length - 1}") if (data.length - 1) < length
        sliced = data.slice(length + offset + 1, data.length - length - 1)
        value = data[offset+1..(length + offset)]
        return [value, sliced]
      end
    end
  end
end

