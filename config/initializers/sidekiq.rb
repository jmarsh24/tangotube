ActiveJob::TrafficControl.client = Searchkick.redis

class Searchkick::BulkReindexJob
  concurrency 3
end

class Searchkick::ReindexV2Job
  concurrency 5
end
