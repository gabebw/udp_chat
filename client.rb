# CLIENT sends data TO someone else
require "socket"

EDWARD_LOCAL_IP_ON_TBOT = "10.173.64.114"

socket = UDPSocket.new

loop do
  data = gets.chomp
  socket.send(data, 0, EDWARD_LOCAL_IP_ON_TBOT, 33333)
  if data == "/quit"
    break
  end
end

socket.close
