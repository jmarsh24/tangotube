MeiliSearch::Rails.configuration = {
  meilisearch_host: Rails.env.production? ? "#{ENV["MEILISEARCH_URL"]}" : "http://localhost:7700",
  meilisearch_api_key: Rails.env.production? ? ENV["MEILI_MASTER_KEY"] : "",
  timeout: 10,
  max_retries: 1
}
