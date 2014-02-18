require "singleton"

class RedisEvents
  include Singleton

  def initialize
    @queue = Queue.new
  end

  def write(messages)
    @queue.push(messages)
  end

  def start(redis, channel)
    Thread.new do
      while batch = @queue.pop
        puts "Publishing #{batch.size} messages"
        redis.pipelined do
          batch.each do |message|
            # puts "RedisEvent - #{message}"
            redis.rpush(channel, message)
            # producer.push(Kafka::Message.new(message))
          end
        end
      end
    end

  end
end
