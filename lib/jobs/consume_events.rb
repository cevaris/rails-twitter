module Jobs
  require 'cassandra'
  
  class ConsumeEvents
    @queue = :consume_events

    def self.perform(args)
      
      puts "Consuming Events #{args}"

      channel = args['channel']
      redis   = Redis.new(Rq::Application.config.redis)
      cassandra = Cassandra.new('APPS', Rq::Application.config.cassandra)

      loop do
        list, messages = redis.blpop(channel)
        json = JSON.parse(message)
        events = json[:events]



      end

    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
