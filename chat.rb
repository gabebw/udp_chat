require "socket"

require "dotenv"
Dotenv.load

# Use your INTERNAL ip
me = { ip: ENV["MY_INTERNAL_IP"], port: ENV["MY_PORT"], name: 'Gabe' }

# Use your friend's EXTERNAL ip
friend = { ip: ENV["THEIR_EXTERNAL_IP"], port: ENV["THEIR_PORT"], name: 'Edward' }

BasicSocket.do_not_reverse_lookup = true
SOCKOPTS = [Socket::SOL_SOCKET, Socket::SO_BROADCAST, true].freeze

sender = UDPSocket.new
sender.setsockopt(*SOCKOPTS)

receiver = UDPSocket.new
receiver.bind(me[:ip], me[:port])
receiver.setsockopt(*SOCKOPTS)

send_thread = Thread.new do
  loop do
    data = $stdin.gets.chomp
    send_message(data, me, friend, sender)
    break if data == "/quit"
  end
end

receive_thread = Thread.new do
  loop do
    data, _ = receiver.recvfrom(1024)
    $stdout.print("#{friend[:name]}: #{data}\n")
    break if data == "/quit"
  end
end

def send_message(message, me, friend, sender)
  $stdout.print "\r\e[A\e[K"
  $stdout.print "#{me[:name]}: #{message}\n"
  sender.send(message, 0, friend[:ip], friend[:port])
end

receive_thread.join
send_thread.join

sender.close
receiver.close
