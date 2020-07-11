require 'socket'
require 'byebug'

require './lib'

s = TCPSocket.new 'localhost', 3306

line_raw = s.recv(1024) # Read lines from socket
  line = StringIO.new(line_raw)

  packetlen = line.read(3).unpack1('s<') # 3 bytes, s< is 16-bit signed, little endian
  packetnum = line.getc.to_i
  puts "<packet> len: #{packetlen}, num: #{packetnum}"

  h = parse_handshake(line)
  puts h.inspect
  # byebug

hr = handshake_response
s.write(wrap_packet(hr, 1))

ok_packet = s.recv(1024)
if ok_packet[4] == "\x00"
  puts "connection phase: success"
else
  raise "Unexpected packet: #{ok_packet}"
end

loop do

  a = [0x03, 0x73, 0x65, 0x6c, 0x65, 0x63, 0x74, 0x20, 0x31]
  s.write(wrap_packet(a.pack("c*"), 0))

  packets = read_packets(s)
  puts packets.inspect

  break
end

