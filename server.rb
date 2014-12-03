# SERVER gets data FROM someone else
require 'socket'

MY_LOCAL_IP_ON_TBOT_GUEST = "10.163.100.144"

socket = UDPSocket.new
# Bind to the same IP that the client is sending to
socket.bind(MY_LOCAL_IP_ON_TBOT_GUEST, 33333)

loop do
  # if this number is too low it will drop the larger packets and never give them to you
  data, addr = socket.recvfrom(1024)

  puts data

  if data == "/quit"
    break
  end
end

socket.close
