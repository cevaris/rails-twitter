require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches Pig job"
    task :create => :environment do

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/tweet-json.pig",
      })
      puts rpig.inspect
      rpig.execute()



      # args = { id: 'fake', dd: rand(10000) }
      # Resque.enqueue(Jobs::Pig, args)


      
    end
  
   
  end

end
