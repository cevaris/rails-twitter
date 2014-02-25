require 'resque/errors'
require 'jobs/pig'
require 'jobs/process_events'

module Jobs
  
  def on_failure_retry(e, *args)
    puts "Performing #{self} caused an exception (#{e}). Retrying..."
    sleep(15)
    Resque.enqueue self, *args
  end

end