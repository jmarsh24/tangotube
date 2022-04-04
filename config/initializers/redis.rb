if ENV["REDISCLOUD_URL"]
  $redis = Redis.new(:url => ENV["REDISCLOUD_URL"])
end

Searchkick.redis = ConnectionPool.new { Redis.new }
