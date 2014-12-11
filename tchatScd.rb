#!/bin/ruby

require 'socket'
require 'logger'

$:.unshift('.')

require 'serverConn.rb'

require './socketObserver.rb'
require './clientSCl.rb'
require './listClientSCl.rb'
require './scTchatCmd.rb'

#print $0
#print $"

require './srvConnPid.rb'

$0 = 'rbsockserv'
SOCKET = "/tmp/observer"

## statup loggger
log = Logger.new("log/server.log", 5, 100*1024)
log.level = Logger::DEBUG
log.datetime_format = "%H:%M:%S"

def serverinit restart  
  pids = `pidof #$0`.chomp
  if restart
    pids.gsub! $$.to_s, '' 
  else
    puts "bye"
  end
  unless pids.empty?
    puts "pid(s) detected: #{pids}"
    system "kill #{pids}"
    puts "killing old pid(s)"
  end
  system "rm #{SOCKET}"
  sleep 1
end

if ARGV.include? "-s"
  puts "stopping server"
  serverinit false
end

begin
  sock = UNIXServer.open(SOCKET)
rescue Errno::EADDRINUSE 
  puts "Address in use."
  exit 1 unless ARGV.include? "-f"
  puts "Removing old socket file"
  serverinit true
  retry
end

fork {  
  puts "starting..."
  
  @connhandler = ServerConn.new ListClientSCl.new, log
  loop {
    break if @connhandler.conn(sock) == 1
  }
}
