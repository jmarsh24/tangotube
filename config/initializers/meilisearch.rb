MeiliSearch::Rails.configuration = {
  meilisearch_host: Rails.env.production? ? ENV["MEILISEARCH_URL"] : "http://localhost:7700",
  timeout: 10,
  max_retries: 1
}
