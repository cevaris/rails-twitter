require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches Pig job"
    task :test => :environment do

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/top-20-most-tweeted-locations.pig",
        jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar'],
        execute: 'local',
        params: {input: 'cql://applications/events', bucket: '2014-02-28-20'}
      })
      puts rpig.inspect
      rpig.execute()

      # args = { id: 'fake', dd: rand(10000) }
      # Resque.enqueue(Jobs::Pig, args)
      
    end
  
   
  end

end
