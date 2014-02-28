module Jobs
  # require 'cassandra'
  require 'cql'
  require 'json'
  require 'securerandom'
  
  class ConsumeEvents
    @queue = :consume_events



    def insert_event(args)
      %{INSERT INTO applications.events (bucket, id, app_id, event) VALUES ('#{args[:bucket]}', now(), #{args[:app_id]}, '#{args[:event]}');}
    end


    def self.perform(args)
      
      puts "Consuming Events #{args}"

      channel = args['channel']
      @redis   = Redis.new(Rq::Application.config.redis)
      @cassandra = Cql::Client.connect(Rq::Application.config.cassandra)
      loop do


        list, messages = @redis.blpop(channel)
        json = JSON.parse(messages)
        events = json['events']

        args = {}
        args[:app_id] = json['app']['id']
        args[:bucket] = Time.now.getutc.strftime "%Y-%m-%d-%H"

        # events.each do |event|
        #   # @cassandra.insert('EVENTS',"#{app_id}:#{bucket}")
        #   puts "WRITING : #{app_id} - #{bucket} - #{event} "
        # end
        
        events.each do |event|
          args[:event] = event
          puts insert_event(args)
        end


      end

    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
