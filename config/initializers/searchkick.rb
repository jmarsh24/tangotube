Searchkick.client_options = {
  url: ENV["ELASTICSEARCH_URL"],
  retry_on_failure: true,
  transport_options:
    { request: { timeout: 10000 } }
}

Searchkick.redis = Redis.new
