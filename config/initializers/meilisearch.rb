MeiliSearch::Rails.configuration = {
  meilisearch_host: "http://#{ENV.fetch("MEILISEARCH_URL", '127.0.0.1:7700')}",
  meilisearch_api_key: ENV.fetch('MEILI_MASTER_KEY', nil),
  timeout: 10,
  max_retries: 1
}
