module Jobs
  
  class ProcessEvents
    @queue = :process_events

    def process(app)
      puts app.name

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/tweet-json.pig",
        jars: ['/Users/cevaris/Documents/workspace/pig/udfs/udfs/bin/epic.jar']
      })
      puts rpig.inspect
      rpig.execute()
    end

    def self.perform(args)
      
      puts "Process Events #{args}"

      EventApplication.all.map { |app| process(app)}

      




    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
