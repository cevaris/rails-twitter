require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches Pig job"
    task :test => :environment do

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/tweet-json.pig",
        jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar'],
        execute: 'local'
      })
      puts rpig.inspect
      rpig.execute()



      # args = { id: 'fake', dd: rand(10000) }
      # Resque.enqueue(Jobs::Pig, args)


      
    end
  
   
  end

end
