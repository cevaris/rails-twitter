
class RHadoop

  def initialize(options={})

    @username = 'vagrant'
    @host = '192.168.3.100'
    @execute = 'local'
    @params = {}

    options.each { |k,v| instance_variable_set("@#{k}", v) }  
    check_preconditions()  

  end

  def check_preconditions()
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


  def hadoop_command()
    # dse hadoop fs -cat /user/vagrant/event_metrics/2/2014-03-06-03/top_langs/part-r-00000
    # dse hadoop fs -cat <REMOTE_FILE_PATH>
    if @execute == 'local'
      "cat /home/#{@username}/event_metrics/#{@app_id}/#{@bucket}/#{@metric}/part-r-00000"
    else
      "dse hadoop fs -cat /user/#{@username}/event_metrics/#{@app_id}/#{@bucket}/#{@metric}/part-r-00000"
    end
  end



  def execute()

    # Execute file 
    command = hadoop_command()
    @response = send_command(command)
    puts @response
  end

  def tab_scan
    @response.split("\n").each do |line|
      yield line.split("\t")
    end
  end

  def char_scan
    @response
    # @response.split("\n").each do |line|
    #   yield line.split("\t")
    # end
  end

end 