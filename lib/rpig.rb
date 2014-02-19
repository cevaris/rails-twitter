
class RPig

  def initialize(options={})

    @username = 'vagrant'
    @remote_script_location = '/pig/dev'
    @host = '192.168.3.100'
    @execute = 'local'

    options.each { |k,v| instance_variable_set("@#{k}", v) }  
    check_preconditions()  

  end

  def pig_path()
    # /pig/dev or /pig/production
    "/pig/#{@remote_script_location}/"
  end

  def username_host
    # <USERNAME>@<HOST>
    "#{@username}@#{@host}"
  end

  def push_file()
    # scp <PIG_SCRIPT_FILE> <REMOTE_LOCATION>:<PIG_SCRIPT_LOCATION>
    command = "scp #{@local_script_location} #{username_host()}:#{pig_path()}"
    puts command
    puts `#{command}`
  end

  def pig_command()
    if @local_script_location
      # dse pig -x <EXECUTION_TYPE> -f <PIG_SCRIPT_FILE>
      "dse pig -x #{@execute} -f #{pig_path()}#{File.basename(@local_script_location)}"
    elsif 
      fail "Pig script file is missing"
    end
  end


  def send_command(command)
    ssh_command = "ssh #{username_host()} #{command}"
    puts ssh_command
    puts `#{ssh_command}`
  end


  def execute()
    # First push file
    push_file()
    # Execute file 
    send_command(pig_command())
  end


  def check_preconditions()
    fail "Pig Script file missing" if @local_script_location.nil?
    fail "Username missing" if @username.nil?
  end

end 

# if __FILE__ == $0

#   $options = {}

#   optparse = OptionParser.new do|opts|
#     opts.banner = "Usage: rpig.rb [options]"

#     $options[:verbose] = false
#       opts.on( '-v', '--verbose', 'Output more information' ) do
#       $options[:verbose] = true
#     end

#     @execute = 'local'
#     opts.on( '-x', '--execute [local|mapreduce]', 'Execute pig script locally or use mapreduce solution' ) do |value|
#       @execute = value.strip().downcase 
#     end

#     @remote_script_location = 'dev'
#     opts.on( '-e', '--environment [dev|prod]', 'Store pig script in developer or production environment' ) do |value|
#       @remote_script_location = value.strip().downcase 
#     end

#     @host = 'epic-n100.int.colorado.edu'
#     # opts.on( '-h', '--host [HOST]', 'Host location of DSE server' ) do |value|
#     #   # @host = value.strip()
#     #   fail "Check yourself before you wreck yourself :)"
#     # end

#     opts.on( '-u', '--username [USERNAME]', 'Username to execute script' ) do |value|
#       @username = value.strip()
#     end

#     opts.on( '-f', '--file [PIG_FILE]', 'Location to Pig script file' ) do |value|
#       @local_script_location = value.strip()
#     end

#     opts.on( '-h', '--help', 'Display this screen' ) do
#       puts opts
#       exit
#     end
#   end

#   optparse.parse!

#   check_preconditions()
#   execute()
# end