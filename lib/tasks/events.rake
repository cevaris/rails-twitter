require 'securerandom'
require 'tweetstream'

require 'net/http'
require 'net/https'

require "redis"
require "json"

require 'jobs'
require 'rpig'


namespace :events do



  desc "Check running Applications"
  task :process => :environment do
    
    args = {}
    Resque.enqueue(Jobs::ProcessEvents, args)

  end


  desc "Check consuming Applications Events"
  task :consume => :environment do
    
    # args = {channel: EventApplication::RAW_EVENTS}
    # Resque.enqueue(Jobs::ConsumeEvents, args)

  end







  desc "Tail from the Redis Queue"
  task :tail, [:channel] => :environment do |task, args|
    channel    = args[:channel].to_s
    redis = Redis.new(Rq::Application.config.redis)

    puts "==> #{channel} <=="

    loop do
      list, message = redis.blpop(channel)
      puts message
      # json = JSON.parse(message)
      # puts json
    end

  end

  task :create => :environment do

    creds = JSON.parse(File.read("#{Rails.root}/.credentials.json"))

    TweetStream.configure do |config|
      config.consumer_key       = creds['consumer_key']
      config.consumer_secret    = creds['consumer_secret']
      config.oauth_token        = creds['oauth_token']
      config.oauth_token_secret = creds['oauth_token_secret']
      config.auth_method        = :oauth
    end

    uri = URI.parse("http://localhost:3000/events")

    apps = EventApplication.all.to_a
    buffer = rand(3)+1
    count  = 0
    tweets = []

    TweetStream::Client.new.sample do |status|
      if count >= buffer
        app = apps.sample
        payload = { events: tweets, app: { id: app.uuid } }.to_json
        Net::HTTP.post_form(uri, {raw_events: payload})
        
        puts "Sent #{count} tweets"
        buffer = rand(3)+1
        count  = 0
        tweets = []
      else  
        tweets << status
        count += 1
      end
    end
  end
end
