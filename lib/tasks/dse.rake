require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches fake Pig job"
    task :create => :environment do
      puts "Running"

      rpig = RPig.new()
      puts rpig.inspect

      # args = { id: 'fake', dd: rand(10000) }
      # Resque.enqueue(Jobs::Pig, args)


      
    end
  
   
  end

end
