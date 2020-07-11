
class HandshakePacket
  attr_accessor :protocol, :version, :connid, :cap, :extcap, :server_status, :encoding
end

def parse_handshake(line)
  hs = HandshakePacket.new

  # line.shift(4)

  hs.protocol = line.getc.unpack1("c")
  version = ""

  loop do
    c = line.getc
    break if c == "\x00"
    version << c
  end
  hs.version = version

  hs.connid = line.read(4).unpack1('V')
  line.read(8)

  line.pos = line.pos+1

  hs.cap = line.read(2).unpack1("S<")
  hs.encoding = line.getc.unpack1("C")
  hs.server_status = line.read(2).unpack1("S<")

  hs.extcap = line.read(2).unpack1("S<")
  # hs.authlen = line.getc.unpack1("C")

  line.pos = line.pos+10
  hs
end
