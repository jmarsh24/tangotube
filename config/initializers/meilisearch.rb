MeiliSearch::Rails.configuration = {
  meilisearch_host: "http://#{ENV["MEILISEARCH_URL"]}" || "http://localhost:7700",
  meilisearch_api_key: ENV["MEILI_MASTER_KEY"] || "",
  timeout: 2,
  max_retries: 1
}
