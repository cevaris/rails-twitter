module Jobs
  
  class Pig
    @queue = :pig

    def self.perform(args)
      
      puts "Pig Job #{args}"


    rescue SQLite3::BusyException => e
      on_failure_retry(e, args)
    end


  end

end
