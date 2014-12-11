# -*- coding: utf-8 -*-

ScTchatCmd = Struct.new(:send, :login, :key, :tchat, :dest, :pid)

class ScTCmdValid
  
  LOGLEN = (5..11)
  LOGREXP = /[!¡^`{}<>?\/\\]/
  TCMAXLEN = 250
  TCREXP = /[<>\`]/

public

  def initialize tc
    raise "Class error"  unless tc.class.to_s.eql? "ScTchatCmd"
    @tc = tc
    raise "Unknow command"  unless ["hello", "quit", "spkuser", "spkroom"].include? tc.send
    raise "No PID set" unless tc.pid.to_s.match(/^[\d]{4,5}$/)
    tc.pid = tc.pid.to_s.chomp
  end

  def valid?
    hello unless @tc.send.eql? "hello"
    method(@tc.send).call
    return true
  end

protected

  def hello
    log? @tc.login
  end

  def quit    
  end

  def spkuser
    raise "Message not set" if @tc.tchat.nil?
    raise "Recipient not set" if @tc.dest.nil?
    tchat?
    log? @tc.dest, "Recipient"
  end

  def spkroom
    raise "Message not set" if @tc.tchat.nil?
    tchat? 
  end

private

  def log? log, what="Login"
    raise "#{what} not set" if log.nil?
    raise "#{what} must count #{LOGLEN.min} min char and #{LOGLEN.max} max char"  unless LOGLEN.include? log.length
    raise "Invalid char for #{what.downcase}"  if log.match(LOGREXP)
  end
  
  def tchat?
    raise "Message too long" if @tc.tchat.length > TCMAXLEN
    @tc.tchat.gsub! TCREXP, ''
  end

end

