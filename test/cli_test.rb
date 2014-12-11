#!/bin/ruby

$0 = "ruby_tcl"
$:.unshift "./test"
require 'test/unit'
require 'tchatTestLib.rb'


def vpid
  pids = `pidof ruby_tcl`.chomp.gsub!($$.to_s, '')
  return 0 if pids.nil?
  return pids.split(' ').length
end
def vpid_t
  pids = `pidof ruby_tcl`.chomp.gsub!($$.to_s, '')
  return 0 if pids.nil?
  return pids.split(' ')
end

class TestTchatServer < Test::Unit::TestCase

  def setup
    @pids = vpid_t
  end

  def test_user    
    uS = []

    puts "test_spkuser: connecting clients..."
    4.times { |t|    
      uS.push TcTstLib.log1U
    }
    sleep 0.1
    2.times {     
      TcTstLib.spkuser uS[1], "testspeakuser", uS[3]
      sleep 0.3
      assert_equal("\"Message=\\ntuser: user:#{uS[1]} say:testspeakuser\"\n", TcTstLib.lastusermess(uS[3]))
    }
    sleep 0.1
    TcTstLib.logoff uS
  end

  def test_logoff
    v_lengthpid = vpid
    puts "connecting clients..."
    cls = []
    5.times { |t|    
      cls.push TcTstLib.log1U
      sleep 1
      assert_equal(v_lengthpid+t+1, vpid)
    }
    sleep 2
    puts "logoff client 3-4"
    TcTstLib.uQuit cls[3]
    sleep 0.5
    TcTstLib.uQuit cls[4]
    sleep 1
    assert_equal(v_lengthpid+3, vpid)
    puts "logoff client 2"
    TcTstLib.uQuit cls[2]
    sleep 3
    assert_equal(v_lengthpid+2, vpid)
    puts "logoff client 0-1"
    TcTstLib.uQuit cls[0]
    sleep 0.1
    TcTstLib.uQuit cls[1]
    sleep 0.1
    assert_equal(v_lengthpid, vpid)
  end

  def test_room 

    puts "test room: connecting clients..."
    uS = []
    4.times { |t|
      uS.push TcTstLib.log1U
      sleep 0.1
    }
    sleep 1
    2.times {
      TcTstLib.spkroom uS[2], "testspeakroom"
      sleep 0.3
      uS.each { |u|
        assert_equal "\"Message=\\ntroom: user:#{uS[2]} say:testspeakroom\"\n", TcTstLib.lastusermess(u)
      }
    }
    sleep 1
    TcTstLib.logoff uS

  end

  def teardown
    unless vpid_t == 0
      vpid_t.each { |p|
        system "kill #{p}" unless (@pids.include? p)
      }
      assert_equal(@pids.length-vpid, 0)    
    end
  end

end
