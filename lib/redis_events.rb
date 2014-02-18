require "singleton"

class RedisEvents
  include Singleton

  def initialize
    @queue = Queue.new
  end

  def write(messages)
    @queue.push(messages)
  end

  def start(channel)
    @redis = Redis.new(Rq::Application.config.redis)
    Thread.new do

      loop do
        batch = @queue.pop
        batch.each do |message|
          # puts "RedisEvent - #{message}"
          result = @redis.rpush(channel, message)
        end
      end

    end

  end
end
