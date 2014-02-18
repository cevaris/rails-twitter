require "redis"
require "json"

redis = Redis.new(:host => 'localhost', :port => 6380, :db => 15, :thread_safe => true)
RedisEvents.instance.start(redis, 'raw.events')

# producer = Kafka::Producer.new(host: 'localhost', port: '9092', topic: "events")
# KafkaEvents.instance.start(producer)
