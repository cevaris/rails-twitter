
class RPig

  def initialize(options={})

    @local_script_path = 'NOT_DEFINED'
    @username = 'vagrant'
    @remote_script_path = '/deployment/pig/'
    @host = '192.168.3.100'
    @execute = 'mapreduce'
    @params = []
    @jars = []

    options.each { |k,v| instance_variable_set("@#{k}", v) }  
    check_preconditions()  

  end

  def send_command(command)
    puts command
    puts `#{command}`
  end

  def username_host
    # <USERNAME>@<HOST>
    "#{@username}@#{@host}"
  end

  def push_jar(jar_path)
    # rsync <PIG_SCRIPT_FILE> <REMOTE_LOCATION>:<PIG_SCRIPT_LOCATION>
    command = "rsync #{jar_path} #{username_host()}:#{@remote_script_path}udfs/"
    send_command(command)
  end

  def push_file(file_path)
    # rsync <PIG_SCRIPT_FILE> <REMOTE_LOCATION>:<PIG_SCRIPT_LOCATION>
    command = "rsync #{file_path} #{username_host()}:#{@remote_script_path}scripts/"
    send_command(command)
  end

  def gen_params()
    return '' if @params.empty?

    args = []
    @params.each do |key, value|
      # if value.respond_to?(:to_i)
      if value.instance_of? Fixnum
        args << "-param #{key}=#{value.to_i}"
      else
        args << "-param #{key}='#{value}'"
      end
    end

    args.join(' ')
  end

  def pig_command()
    if @local_script_path
      # dse pig -x <EXECUTION_TYPE> -f <PIG_SCRIPT_FILE>
      "dse pig -x #{@execute} #{gen_params()} -f #{@remote_script_path}scripts/#{File.basename(@local_script_path)}"
    elsif 
      fail "Pig script file is missing"
    end
  end



  def execute()
    # First push file
    push_file(@local_script_path)

    # Push any jar files
    @jars.each do |jar_path|
      push_jar(jar_path)
    end

    # Execute file 
    command = "ssh #{username_host()} #{pig_command()}"
    send_command(command)
    
  end


  def check_preconditions()
    fail "Pig Script file missing" if @local_script_path.nil?
    fail "Pig Script file not found: #{@local_script_path}" unless File.exist?(@local_script_path)
    fail "Username missing" if @username.nil?
  end

end 