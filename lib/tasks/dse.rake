require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches ALL Pig job"
    task :all => :environment do

      Dir.glob(File.join("#{Rails.root}/scripts/pig/production", "*.pig")).each do |script|
        args = { script: script }
        Resque.enqueue(Jobs::ExecutePigScript, args)
      end
      
    end

    desc "Launches Pig job"
    task :script, [:script] => :environment do |task, args|

      Resque.enqueue(Jobs::ExecutePigScript, args)

      # rpig = RPig.new({ 
      #   local_script_path: "#{Rails.root}/scripts/pig/production/#{args['script']}",
      #   jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar'],
      #   execute: 'local',
      #   params: {input: 'cql://applications/events', bucket: '2014-02-28-20'}
      # })
      # puts rpig.inspect
      # rpig.execute()
      
    end
  
   
  end

end
