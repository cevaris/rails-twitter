module Jobs
  require 'cassandra'
  
  class ConsumeEvents
    @queue = :consume_events

    def self.perform(args)
      
      puts "Consuming Events #{args}"

      channel = args['channel']
      @redis   = Redis.new(Rq::Application.config.redis)
      @cassandra = Cassandra.new('APPS', Rq::Application.config.cassandra)

      puts @cassandra.keyspaces

      loop do
        list, messages = @redis.blpop(channel)
        # puts "#{list} #{messages}"
        json = JSON.parse(messages)
        events = json['events']
        app_id = json['app']['id']

        events.each do |event|
          puts "WRITING : #{app_id} - #{event} "
        end


      end

    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
