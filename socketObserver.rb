require 'monitor'

class SocketObserver

  @@lock = Monitor.new

  attr_writer :log, :sock
  attr_reader :sock

  def fkd_hello clS
    if clS.login?
      @sock.send "login already used", 0
      return -1
    else
      rep = clS.comein
      @sock.send rep, 0
      wait clS
    end
  end

  def srv_req clS, tchatCmd
    case tchatCmd.send
    when "quit"
      clS.quit      

    when "spkroom"
      clS.tchat_room tchatCmd.tchat     

      @log.info "cl #{tchatCmd.login}  speak on room, wanttosay #{tchatCmd.tchat}"

    when "spkuser"
      clS.tchat_user tchatCmd.tchat, tchatCmd.dest
      
      @log.info "cl #{tchatCmd.login} tchat user #{tchatCmd.dest}, wanttosay #{tchatCmd.tchat}"
    end
  end

private

  def wait clS
    Thread.new {
      loop {        
        # @@lock.synchronize {
          rep = wait_notify(clS)
          @sock.send rep, 0
        #}
        @log.debug "notifying client - #{clS.login}"
        break if rep == "bye"
      }
    }
    return 0
  end

   def wait_notify clS
    loop {    
       @log.warn " thread cl:#{clS.login} wait, count=#{clS.count}" 
      case clS.receive
      when "loginoff"
        @log.info("client #{clS.login} quit")
        return "bye"
      when "count"
        return "count= #{clS.count}"
      when "room"
        @log.debug("some message on tchat room")
        return clS.room?
      when "user"
        @log.debug("some message for user #{clS.login}")
        return clS.user?
      end
    }
  end

end
