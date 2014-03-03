require 'jobs'

Resque.redis = Redis.new(Rq::Application.config.redis)


# Starts only one worker
if Resque.size('consume_events') == 0
  puts "Start Consumer #{Resque.size('consume_events')} "
  Resque.enqueue(Jobs::ConsumeEvents, {channel: EventApplication::RAW_EVENTS})
else
  # Delete any queued consumers
  Resque.redis.del "resque:queue:consume_events"
end