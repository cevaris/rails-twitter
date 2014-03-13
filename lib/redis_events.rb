require "singleton"

class RedisEvents
  include Singleton

  def dump_events(messages)
    # puts "RedisEvents - #{messages}"
    result = $redis.rpush(Application::RAW_EVENTS, messages)
  end

end
