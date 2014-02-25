require 'jobs'

Resque.redis = Redis.new(Rq::Application.config.redis)


# Start demon
Resque.enqueue(Jobs::ConsumeEvents, {channel: EventApplication.RAW_EVENTS})