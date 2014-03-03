require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches ALL Pig job"
    task :test => :environment do


    Dir.glob(File.join("#{Rails.root}/scripts/pig/production", "*.pig")).each do |script|
      rpig = RPig.new({ 
        # local_script_path: "#{Rails.root}/scripts/pig/top-20-most-tweeted-locations.pig",
        local_script_path: script,
        jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar'],
        # execute: 'local',
        params: {input: 'cql://applications/events', bucket: '2014-02-28-20'}
      })
      puts rpig.inspect
      rpig.execute()
    end

      # args = { id: 'fake', dd: rand(10000) }
      # Resque.enqueue(Jobs::Pig, args)
      
    end

    desc "Launches Pig job"
    task :script, [:script] => :environment do |task, args|

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/production/#{script}",
        local_script_path: ,
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
