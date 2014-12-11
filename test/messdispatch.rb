$0 = "ruby_tcl"
$:.unshift "./test"
require 'test/unit'
require 'tchatTestLib.rb'

class Messdispatch < Test::Unit::TestCase

  def setup
    puts "starting..."

  end

  def test_deb

    n = TcTstLib.log1U
    assert_match(/^tstusr(\d{1,5}$)/, n)
    sleep 1
    TcTstLib.uQuit n    
  end

  def test_mdroom
    t = []
    2.times { |i|
      t[i] = TcTstLib.log1U
      sleep 0.1
      TcTstLib.spkroom t[i], "hello I am #{t[i]} *#!..." 
    }
    sleep 0.1
    t.each { |n|
      TcTstLib.uQuit n
      sleep 0.1
    }    
  end

  def test_syncroom
    n = TcTstLib.log1U
    sleep 0.5
    1.times {
      TcTstLib.spkroom n, "hellxs I am #{n} " 
    }
    sleep 0.1
    TcTstLib.uQuit n
  end

  def teardown
    puts "test finished"
  end


end
