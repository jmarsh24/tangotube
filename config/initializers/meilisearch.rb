MeiliSearch::Rails.configuration = {
  meilisearch_host: ENV.fetch('MEILISEARCH_HOST', 'http://127.0.0.1:7700'),
  meilisearch_api_key: ENV.fetch('MEILISEARCH_API_KEY', nil)
}
