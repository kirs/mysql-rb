module MysqlRb
  module PacketHelpers
    private

    def length_binary(str)
      return [str.length, str].pack("Ca*") if str.length <= 250
      return [str.length, str].pack("va*") if str.length <= 32767
      return [str.length, str].pack("Va*") if str.length <= 2147483647
      return [str.length, str].pack("Qa*")
    end

    def get_length_binary_nonmut(data)
      if data[0].unpack1("c") == 252
        b, length = data.unpack('Cv')
        offset = 2
      elsif data[0].unpack1("c") == 253
        b, length = data.unpack('CV')
        offset = 4
      elsif data[0].unpack1("c") == 254
        b, length = data.unpack('CQ')
        offset = 8
      else
        return data[0].unpack1("c")
      end
      value = data[offset+1..(length + offset)]
    end

    def get_lenenc_str(packet)
      len, packet = get_length_binary(packet)
      if len == 0
        ["", packet]
      else
        [packet[0..len-1], packet[len..]]
      end
    end

    def get_length_binary(data)
      raise Exception.new("Unable to parse length binary: no data") if data.nil? or data.empty?

      if data[0].unpack1("c") == 252
        _b, length = data.unpack('Cv')
        offset = 2
      elsif data[0].unpack1("c") == 253
        _b, length = data.unpack('CV')
        offset = 4
      elsif data[0].unpack1("c") == 254
        _b, length = data.unpack('CQ')
        offset = 8
      else
        return [data[0].unpack1("c"), data[1..]]
      end

      if data[0] == 251
        #raise Exception.new("unexpected NULL column value, only expected in row data packet") if @substate != SubState::WAIT_RESULT_SET_DATA
        return [nil, data.slice(1, data.length - 1)]
      else
        raise Exception.new("Unable to parse length binary: expected: #{length}, got: #{data.length - 1}") if (data.length - 1) < length
        sliced = data.slice(length + offset + 1, data.length - length - 1)
        value = data[offset+1..(length + offset)]
        return [value, sliced]
      end
    end
  end

end

