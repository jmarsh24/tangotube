require "active_job/traffic_control"

Sidekiq.configure_server do |config|
  config.redis = {url: ENV["REDIS_URL"]}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["REDIS_URL"]}
end

ActiveJob::TrafficControl.client = Searchkick.redis

class Searchkick::BulkReindexJob
  include ActiveJob::TrafficControl::Concurrency

  concurrency 3, drop: false
end

class Searchkick::ReindexV2Job
  include ActiveJob::TrafficControl::Concurrency

  concurrency 3, drop: false
end


