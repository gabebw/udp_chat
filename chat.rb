require 'socket'

# If you're on OS X, open up System Preferences > Network and look under
# "Status: Connected". It should say "and has the IP address a.b.c.d".
#
# Enter that IP address here.
MY_INTERNAL_IP = "192.168.x.x"

# You and a friend should forward a port (at the router level). They don't need
# to be the same port.

# Let's say you forward external port 1234 to port 5678 on your machine.
MY_PORT = 5678

# Let's say your friend also forwarded external port 1234 to internal port 5678.
# You're connecting to their external connection, so put 1234 below.
THEIR_PORT = 1234

# Tell your friend to google "what's my IP". Put that IP address here.
THEIR_EXTERNAL_IP = "1.2.3.4"

# Use your INTERNAL ip
me = { ip: MY_INTERNAL_IP, port: MY_PORT, name: 'Gabe' }

# Use your friend's EXTERNAL ip
friend = { ip: THEIR_EXTERNAL_IP, port: THEIR_PORT, name: 'Edward' }

BasicSocket.do_not_reverse_lookup = true

sender = UDPSocket.new
sender.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)

receiver = UDPSocket.new
receiver.bind(me[:ip], me[:port])
receiver.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)

send_thread = Thread.new(me, friend, sender) do |me, friend, sender|
  loop do
    puts "Inside send_thread"

    print "> "
    data = $stdin.gets.chomp
    send_message(data, me, friend, sender)
    break if data == '/quit'
  end
end

receive_thread = Thread.new do
  loop do
    puts "Inside receive_thread"

    data, _ = receiver.recvfrom(1024)
    $stdout.print("#{friend[:name]}: #{data}\n")
    break if data == '/quit'
  end
end

def send_message(message, me, friend, sender)
  $stdout.print "\rFrom you: #{me[:name]}: #{message}\n"
  sender.send(message, 0, friend[:ip], friend[:port])
end

receive_thread.join
send_thread.join

sender.close
receiver.close
