class ClientSCl

  attr_reader :login, :tchatroom, :tchatuser, :pid_cur
  attr_writer :tchatroom, :tchatuser

  def initialize lClS, tc
    @login = tc.login
    @key = tc.key
    @connection_start_time = Time.now
    @tchatroom = {}
    @tchatuser = {}
    @scPSrv, @scPCl = UNIXSocket.pair
    @pid_cur = tc.pid
    @listClientSCl = lClS
  end

  def send sowA
    @scPSrv.send sowA, 0
  end

  def receive
    @scPCl.recv(10)
  end

  def comein
    @listClientSCl.add self
    return "hi;#{@listClientSCl.length};"
  end

  def count
    return @listClientSCl.length
  end

  def login?
    @listClientSCl.logged @login
  end

  def quit
    @listClientSCl.remove self
    send "loginoff"
  end

  def tchat_room tchat

    @listClientSCl.tchat @login, tchat
  end

  def tchat_user tchat, login
    cScl = @listClientSCl.logged login
    return -1 if cScl.nil?
    cScl.tchatuser[@login] = tchat
    cScl.send "user"
  end 

  def room?
    msgSrv = ""
    tchatroom.each do |u, t| 
      msgSrv << "\ntroom: user:#{u} say:#{t}"
      tchatroom.delete(u)
    end
    msgSrv
  end

  def user?
    msgSrv = ""
    tchatuser.each { |u, t|           
      msgSrv << "\ntuser: user:#{u} say:#{t}"
      tchatuser.delete(u)
    }
    msgSrv
  end

end
