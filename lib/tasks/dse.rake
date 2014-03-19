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


      app_id = 2
      bucket = '2014-03-06-03'

      documents = {}
      documents[:documents] = []
      documents[:bucket]  = bucket
      documents[:app_id]  = app_id






      # /user/vagrant/event_metrics/2/2014-03-06-03/top_langs/part-r-00000
      rhadoop = RHadoop.new({
        path: "event_metrics/#{app_id}/#{bucket}/top_langs"
      })
      puts rhadoop.inspect
      rhadoop.execute()

      document = {}
      document[:data]  = []
      document[:label] = "Top Languages"
      document[:render] = 'table'
      rhadoop.tab_scan do |line|
        document[:data] << line
      end
      documents[:documents] << document






      #### Map
      rhadoop = RHadoop.new({
        path: "event_metrics/#{app_id}/#{bucket}/top_locations"
      })
      puts rhadoop.inspect
      rhadoop.execute()

      document = {}
      document[:data]  = []
      document[:label] = 'Top Locations'
      document[:render] = 'map'
      rhadoop.tab_scan do |line|
        document[:data] << line[0]
      end
      documents[:documents] << document






      #### Single Char
      rhadoop = RHadoop.new({
        path: "event_metrics/#{app_id}/#{bucket}/counts"
      })
      puts rhadoop.inspect
      rhadoop.execute()

      document = {}
      document[:data]   = rhadoop.string_scan
      document[:label]  = 'Total Tweets'
      document[:render] = 'text'
      documents[:documents] << document





      rhadoop = RHadoop.new({
        command: 'ls',
        path: "event_metrics/#{app_id}"
      })
      puts rhadoop.inspect
      rhadoop.execute()
      rhadoop.tab_scan do |line|
        document[:data] << line[0]
      end

      @metric = Metric.find_or_initialize_by(application_id: app_id, bucket: bucket, data: documents.to_json)
      @metric.save

      puts "Metrics: #{@metric.inspect}"
      puts "Document: #{JSON.pretty_generate(documents)}"

    end
  end

end
