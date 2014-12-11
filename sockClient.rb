#!/bin/ruby
# $:.unshift File.join(File.dirname(__FILE__), "..", "")
$:.unshift "./"
#$:.unshift "/media/data/websoft/src/appConfMg/"
require 'socket'
require 'scTchatCmd.rb'
require 'lib_test.rb'

$0 = "ruby_tcl"
SOCKET = "/tmp/observer"

@required_args = {"-s" => "hello", "-l" => "" , "-t" => "", "-d" => ""}

get_cmdline_args

def reqArg(arg)

  if @required_args[arg].empty?
    puts "#{arg} Not specified"
    exit 1
  end

  return @required_args[arg]
end

def client_send tchatCmd
  data = Marshal.dump(tchatCmd)
  client = UNIXSocket.open(SOCKET)

  client.send(data, 0)

  return client
end


send = reqArg("-s")
tchatCmd = ScTchatCmd.new(send)
tchatCmd["pid"] = $$
case send
when "hello"
  tchatCmd.login = reqArg("-l")
  puts "send pid: #$$ * #{send}"

  socketcl = client_send(tchatCmd)
  msg, addr = socketcl.recvfrom(124)

  p msg if msg[0..4] == "login"
  #srep = msg.split(';')
  # @user_key = srep[2]
  # if @user_key.nil?
  #   puts "error while login -#{srep}-"
  #   exit 1
  # end

  msg = "-1"
  until ["bye", nil, ""].include? msg do
    msg, addr = socketcl.recvfrom(124)
    p "Message=#{msg}"    
  end
when "quit"
  tchatCmd.login = reqArg("-l")
  puts "logoff ..."
  socketcl = client_send(tchatCmd)
when "spkroom" 
  tchatCmd.login = reqArg("-l")
  tchatCmd.tchat = reqArg("-t")
  socketcl = client_send(tchatCmd)
when "spkuser"  
  tchatCmd.login = reqArg("-l")
  tchatCmd.tchat = reqArg("-t")
  tchatCmd.dest = reqArg("-d")  
  socketcl = client_send(tchatCmd)
else
  puts "bad command arg"
  exit 1
end
socketcl.close

