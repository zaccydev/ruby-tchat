class ServerConn

  def initialize lClS, log
    @lClS = lClS
    @log = log
    SrvConnPid.start lClS, log
  end

  def conn sock
    @sock = sock 
    @obs = SocketObserver.new
    @obs.log = @log

    tchatCmd = receive
    return -1 if tchatCmd == -1

    @log.info tchatCmd

    handle_request tchatCmd
  end

private

  def handle_request tchatCmd
    if( ["quit", "spkroom", "spkuser"].include? tchatCmd.send )
      clS = @lClS.logged tchatCmd.login
      return -1 if clS.nil?
      @obs.srv_req clS, tchatCmd

    elsif tchatCmd.send.eql? "hello"
      clS = ClientSCl.new @lClS, tchatCmd
      @obs.fkd_hello clS
    else
      return 1
    end
  end

  def receive
    sock = @sock.accept

    data, addr = sock.recvfrom(500) #124
    @obs.sock = sock
    @log.debug "receiving somebyte from client..."
    
    tchatCmd = Marshal.load(data)
    begin 
      v = ScTCmdValid.new tchatCmd
      v.valid?
    rescue
      @log.warn "Erreur commande: #$!"
      return -1
    end
    return tchatCmd
  end

end
