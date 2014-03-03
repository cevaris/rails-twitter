module Jobs
  
  class ExecutePigScript
    @queue = :execute_pig_script

    def self.perform(args)
      puts "Pig Job #{args}"

      rpig = RPig.new({ 
        local_script_path: args['script'],
        jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar'],
        # execute: 'local',
        params: {input: 'cql://applications/events', bucket: '2014-02-28-20'}
      })
      puts rpig.inspect
      rpig.execute()


    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
