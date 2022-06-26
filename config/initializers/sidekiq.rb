Sidekiq.configure_server do |config|
  config.redis = {url: ENV.REDIS_URL}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV.REDIS_URL}
end

ActiveJob::TrafficControl.client = Searchkick.redis

class Searchkick::BulkReindexJob
  concurrency 3
end

class Searchkick::ReindexV2Job
  concurrency 5
end


