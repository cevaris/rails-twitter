require 'jobs'
require 'rpig'
require 'rhadoop'

require 'json'

namespace :dse do

  namespace :pig do

    desc "Launches ALL Pig job"
    task :all => :environment do

      # Dir.glob(File.join("#{Rails.root}/scripts/pig", "*.pig")).each do |script|
      #   args = { script: script }
      #   Resque.enqueue(Jobs::ExecutePigScript, args)
      # end
      
    end

    desc "Launches Pig job"
    task :script, [:script] => :environment do |task, args|

      rpig = RPig.new({ 
        local_script_path: "#{Rails.root}/scripts/pig/#{args['script']}",
        jars: ['/Users/cevaris/Documents/workspace/pig/pig-json/pig-json.jar',
               '/Users/cevaris/Documents/workspace/pig/pig-dse/pig-dse.jar'],
        execute: 'local',
        # execute: 'mapreduce',
        params: {
          input: 'cql://applications/events', 
          output: 'cql://applications/event_metrics',
          bucket: '2014-03-06-03', 
          app_id: 2
        }
      })
      puts rpig.inspect
      rpig.execute()

    end
  
   
  end


  namespace :hadoop do

    desc "Launches Hadoop job"
    # task :file, [:file] => :environment do |task, args|
    task :execute => :environment do

      # /user/vagrant/event_metrics/2/2014-03-06-03/top_langs/part-r-00000
      rhadoop = RHadoop.new({ 
        bucket: '2014-03-06-03', 
        metric: 'top_langs',
        app_id: 2
      })
      puts rhadoop.inspect
      rhadoop.execute()

      rhadoop.tab_scan do |line|
        puts "Result: #{line}"
      end

      ###
      rhadoop = RHadoop.new({ 
        bucket: '2014-03-06-03', 
        metric: 'counts',
        app_id: 2
      })
      puts rhadoop.inspect
      rhadoop.execute()

      puts "Result: #{rhadoop.char_scan}"

    end
  end

end
