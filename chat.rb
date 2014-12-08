require "socket"

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
SOCKOPTS = [Socket::SOL_SOCKET, Socket::SO_BROADCAST, true].freeze

sender = UDPSocket.new
sender.setsockopt(*SOCKOPTS)

receiver = UDPSocket.new
receiver.bind(me[:ip], me[:port])
receiver.setsockopt(*SOCKOPTS)

SEND_THREAD = Thread.new do
  loop do
    data = $stdin.gets.chomp
    send_message(data, me, friend, sender)
    quit if data.match("/quit")
  end
end

RECEIVE_THREAD = Thread.new do
  loop do
    data, _ = receiver.recvfrom(1024)
    $stdout.print("#{friend[:name]}: #{data}\n")
    quit if data.match("/quit")
  end
end

def send_message(message, me, friend, sender)
  $stdout.print "\r\e[A\e[K"
  $stdout.print "#{me[:name]}: #{message}\n"
  sender.send(message, 0, friend[:ip], friend[:port])
end

def quit
  Thread.kill(SEND_THREAD)
  Thread.kill(RECEIVE_THREAD)
  receiver.close
  sender.close
end

RECEIVE_THREAD.join
SEND_THREAD.join
