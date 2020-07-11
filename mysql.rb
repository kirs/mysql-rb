require 'socket'
require 'byebug'

require './lib'

s = TCPSocket.new 'localhost', 3306

while line_raw = s.recv(1024) # Read lines from socket
  line = StringIO.new(line_raw)

  packetlen = line.read(3).unpack1('s<') # 3 bytes, s< is 16-bit signed, little endian
  packetnum = line.getc.to_i
  puts "<packet> len: #{packetlen}, num: #{packetnum}"

  h = parse_handshake(line)
  puts h.inspect
  # byebug

  # puts line.inspect         # and print them
  break
end

s.close             # close socket when done
