require 'jobs'

Resque.redis = Redis.new(Rq::Application.config.redis)