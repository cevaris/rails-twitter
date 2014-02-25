require "singleton"

class RedisEvents
  include Singleton

  def initialize(channel)
    @channel = channel
  end

  def write(messages)
    messages.each do |message|
      puts "RedisEvent - #{message}"
      result = $redis.rpush(@channel, message)
    end
  end

end
