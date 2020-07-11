
module MysqlRb
  # Credits: https://github.com/chrismoos/async-mysql
  class Row
    attr_accessor :fields, :data, :attributes

    def initialize
      self.data = []
      self.attributes = {}
    end

    def finalize
      @fields.length.times do |x|
        self.attributes[@fields[x].org_name] = @data[x]
      end
    end

    def to_s
      "#<Row attributes=#{attributes}>"
    end

    def method_missing(symbol, *args)
      if self.attributes.has_key? symbol.to_s
        return self.attributes[symbol.to_s]
      else
        super(symbol, args)
      end
    end
  end

  FIELD_TYPES = {
    0x00 => :decimal,
    0x01 => :tiny,
    0x02 => :short,
    0x03 => :long,
    0x04 => :float,
    0x05 => :double,
    0x06 => :null,
    0x07 => :timestamp,
    0x08 => :longlong,
    0x09 => :int24,
    0x0a => :date,
    0x0b => :time,
    0x0c => :datetime,
    0x0d => :year,
    0x0e => :newdate,
    0x0f => :varchar,
    0x10 => :bit,
    0xf6 => :newdecimal,
    0xf7 => :enum,
    0xf8 => :set,
    0xf9 => :tiny_blob,
    0xfa => :medium_blob,
    0xfb => :long_blob,
    0xfc => :blob,
    0xfd => :var_string,
    0xfe => :string,
    0xff => :geometry
  }

  # Credits: https://github.com/chrismoos/async-mysql
  class Column
    attr_accessor :catalog, :db, :table, :org_table, :name, :org_name, :charsetnr, :length, :type, :flags, :decimal, :default

    def type_name
      raise Exception.new("Unknown field type: #{self.type}") if not FIELD_TYPES.has_key? self.type
      return FIELD_TYPES[self.type]
    end

    def to_s
      "#<Column column=#{self.org_name}, type=#{type_name}>"
    end
  end

  class HandshakePacket
    attr_accessor :protocol, :version, :connid, :capability, :server_status, :encoding, :auth_plugin
    attr_accessor :scramble_1, :scramble_2
  end

  class Packet
    attr_accessor :len, :seq, :data

    def self.wrap(bytes, n)
      packet = "".encode("ASCII")
      packet << [bytes.size].pack("L<")[0..2]
      packet << [n].pack("C")
      packet << bytes
      packet
    end
  end
end
