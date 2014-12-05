# CLIENT sends data TO someone else
require "socket"

IP = ARGV[0]
PORT = ARGV[1].to_i

socket = UDPSocket.new

loop do
  print "> "
  data = STDIN.gets.chomp
  socket.send(data, 0, IP, PORT)
  if data == "/quit"
    break
  end
end

socket.close
