
def get_cmdline_args

  while !ARGV[0].nil?
    carg = ARGV.shift
    if @required_args.has_key?(carg)
      if ARGV[0].nil?
        puts "error: bad command line arguments"
        exit 1
      end
      @required_args[carg] = ARGV.shift
      #puts "arg =  #{carg}; value = #{@required_args[carg]} \n"
   end
  end
end
