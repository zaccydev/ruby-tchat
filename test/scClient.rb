require 'test/unit'
require './clientSCl.rb'
require 'socket'

class T_ClientScl < Test::Unit::TestCase

  def test_pid
    cl= ClientSCl.new "nom", "cle", "5480"
    cl.pid_cur = "8500"

    assert_equal(cl.inlist_pid(["8500","1050", "5480"]), true)
    assert_equal(cl.inlist_pid(["8501","1050", "5480"]), true)
    assert_equal(cl.inlist_pid(["8501","1050", "5481"]), false)
    assert_equal(cl.inlist_pid(["8500","1050", "5481"]), true)
  end

  def cleanListPid pids, l
    l.debug("list pid received: #{pids}")
    if (pids.length > 6)
       pids = pids.split(' ')
    else
      pids = [pids]
    l.debug("list pid received: #{listp}")
    end

    count = false
    l.debug("checking inlist_pid")
    @connected.each { |z|
      
      l.debug("#{z.pid_forked}|#{z.pid_cur}")   
      p = pids.find {|p| p == z.pid_cur || p.to_i == z.pid_cur.to_i + 1 }
      if p
        l.debug "deleting client #{z.pid_cur}"
        @connected.delete(z)
        count = true
      end
      
    }
    l.debug("done...")
  end
end
