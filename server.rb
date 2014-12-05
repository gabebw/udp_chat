# SERVER gets data FROM someone else
require 'socket'

IP = ARGV[0]
PORT = ARGV[1].to_i

socket = UDPSocket.new
# Bind to the same IP that the client is sending to
socket.bind(IP, PORT)

loop do
  # if this number is too low it will drop the larger packets and never give them to you
  data, addr = socket.recvfrom(1024)

  puts data

  if data == "/quit"
    break
  end
end

socket.close
