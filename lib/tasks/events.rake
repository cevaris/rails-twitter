require 'securerandom'
require 'tweetstream'

require 'net/http'
require 'net/https'

require "redis"
require "json"


namespace :events do
  desc "Tail from the Redis Queue"
  task :tail, [:channel] => :environment do |task, args|
    channel    = args[:channel].to_s
    redis = Redis.new(Rq::Application.config.redis)

    puts "==> #{channel} <=="

    loop do
      list, message = redis.blpop(channel)
      json = JSON.parse(message)
      puts json
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

    buffer = rand(50)
    count  = 0
    tweets = []
    TweetStream::Client.new.sample do |status|
      if count >= buffer
        # puts "Writing out tweets #{count}:#{buffer}"
        Net::HTTP.post_form(uri, {events: tweets.to_json})
        puts "Sent #{count} tweets"
        buffer = rand(50)
        count  = 0
        tweets = []
      else  
        # puts "Queuing tweets #{count}:#{buffer}"
        tweets << status
        count += 1
      end
    end
  end
end
