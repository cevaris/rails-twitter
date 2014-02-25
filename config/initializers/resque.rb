require 'jobs'

Resque.redis = Redis.new(Rq::Application.config.redis)


# Delete all queued workers for consuming events
Resque.redis.del "queue:consume_events"
# Start workers for consuming events
Resque.enqueue(Jobs::ConsumeEvents, {channel: EventApplication::RAW_EVENTS})