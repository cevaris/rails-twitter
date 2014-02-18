require "redis"
require "json"

redis = Redis.new(Rq::Application.config.redis)
RedisEvents.instance.start(redis, 'events:raw')