module Jobs
  
  class ConsumeEvents
    @queue = :consume_events

    def self.perform(args)
      
      puts "Consuming Events #{args}"

      channel = args[:channel]
      redis   = Redis.new(Rq::Application.config.redis)

      puts "==> #{channel} <=="


      loop do
        list, messages = redis.blpop(channel)
        puts "CONSUMED: #{messages}"
        # json = JSON.parse(message)
        # puts json
      end
      

    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
