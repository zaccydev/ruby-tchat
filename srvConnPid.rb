require 'serverConn.rb'

class SrvConnPid < ServerConn

  private_class_method :new

  @@up = false

  def initialize lClS, log
    @log = log
    @lClS = lClS
    pid_sync
  end

  def self.start lClS, log
    @@up = new(lClS, log) unless @@up    
  end

private

  def pid_sync
    Thread.new {
      loop {  sleep 3
        pids = `pidof ruby_tcl`.chomp.split(' ')
        next if (pids.nil? || pids.empty?)
        rm_vacants(pids)
        @log.debug "list pid sended: #{pids}"
      }
    }
  end

  def rm_vacants pids
    list = @lClS.pidlist
    vpids = list.reject { |p| pids.include? p }
    @lClS.remove_by_pid vpids, @log 
  end

end
