class ListClientSCl

  def initialize
    @connected = []
  end

  def logged login
    @connected.each { |c| return c if c.login.eql?(login) }
    return nil
  end

  def keyExist? key
    @connected.each { |c| return true if c.key.eql?(key) }
    return false
  end

  def count    
    @connected.each { |c| c.send "count" }
  end

  def add clientSocketCl    
    @connected.push clientSocketCl
    count
  end

  def remove clS
    @connected.delete clS
    count
  end

  def remove_by_pid pids, l
    pids.each { |p|
      @connected.find { |c| c.pid_cur == p }.quit
    }
  end

  def length
    return @connected.length
  end

  def tchat login, tchat
    @connected.each { |c| 
      c.tchatroom[login] = tchat
      c.send "room"
    }
  end

  def pidlist
    list = []
    @connected.each { |c| list.push(c.pid_cur) }
    list
  end

end
