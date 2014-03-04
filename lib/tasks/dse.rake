require 'jobs'
require 'rpig'

namespace :dse do

  namespace :pig do

    desc "Launches ALL Pig job"
    task :all => :environment do

      Dir.glob(File.join("#{Rails.root}/scripts/pig", "*.pig")).each do |script|
        args = { script: script }
        Resque.enqueue(Jobs::ExecutePigScript, args)
      end
      
    end

    desc "Launches Pig job"
    task :script, [:script] => :environment do |task, args|

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/#{args['script']}",
        jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar'],
        execute: 'local',
        # execute: 'mapreduce',
        # params: {input: 'cql://applications/events', bucket: '2014-02-28-20'}
        params: {input: 'cql://applications/events?init_address=192.168.3.100', bucket: '2014-02-28-20'}
      })
      puts rpig.inspect
      rpig.execute()
      
    end
  
   
  end

end
