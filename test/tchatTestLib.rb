class TcTstLib
  @@tmpdir = File.dirname(__FILE__) + "/tmp"
  @@clfile = File.dirname(__FILE__) + "/../sockClient.rb"
  
  def initialize

  end

  def self.log1U name='', rand=true
  
    if rand == true
      rnd = rand(10e4) 
      name = "tstusr#{rnd}"
    end
    system "#{@@clfile} -s hello -l #{name} > #{@@tmpdir}/f_#{name}.tmp &"
    name
  end

  def self.userfile name
    return "#{@@tmpdir}/f_#{name}.tmp"
  end

  def self.uQuit name
    system "#{@@clfile} -s quit -l #{name}"
  end

  def self.spkroom name, say 
    system "#{@@clfile} -s spkroom -t #{say} -l #{name}"
  end

  def self.spkuser name, say, dest
    system "#{@@clfile} -s spkuser -t #{say} -l #{name} -d #{dest}"
  end

  def self.lastusermess name
    @vline=""
      File.open(self.userfile(name), "r+") { |lines|
        while (l = lines.gets) do
          @vline=l
          next
        end
      }
    @vline
  end

  def self.logoff cls
    cls.each { |c|
      self.uQuit c
      sleep 0.1
    }
  end

end
