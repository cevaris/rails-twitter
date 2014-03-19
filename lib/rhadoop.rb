
class RHadoop

  def initialize(options={})


    @command = 'cat'
    @username = 'vagrant'
    @host = '192.168.3.100'
    @execute = 'local'
    @params = {}

    options.each { |k,v| instance_variable_set("@#{k}", v) }  
    check_preconditions()  

  end

  def check_preconditions()
    @command.downcase!

    fail "Username missing" if @username.nil?
  end

  def send_command(command)
    puts "ssh #{username_host()} #{command}"
    `ssh #{username_host()} #{command}`
  end

  def username_host
    # <USERNAME>@<HOST>
    "#{@username}@#{@host}"
  end




  def cat_command()
    # dse hadoop fs -cat /user/vagrant/event_metrics/2/2014-03-06-03/top_langs/part-r-00000
    # dse hadoop fs -cat <REMOTE_FILE_PATH>
    if @execute == 'local'
      "cat /home/#{@username}/#{@path}/part-r-00000"
    else
      "dse hadoop fs -cat /user/#{@username}/#{@path}/part-r-00000"
    end
  end

  def ls_command()
    # dse hadoop fs -cat /user/vagrant/event_metrics/2/2014-03-06-03/top_langs/part-r-00000
    # dse hadoop fs -cat <REMOTE_FILE_PATH>
    if @execute == 'local'
      "ls /home/#{@username}/#{@path}"
    else
      "dse hadoop fs -ls /user/#{@username}/#{@path}"
    end
  end





  def execute()

    command = case @command
      when 'ls' then ls_command()
      when 'cat' then cat_command()
    end

    @response = send_command(command)
    puts @response
  end


  def scan
    @response.split("\n").each do |line|
      yield line
    end
  end

  def tab_scan
    @response.split("\n").each do |line|
      yield line.split("\t")
    end
  end

  def string_scan
    @response
  end

end 