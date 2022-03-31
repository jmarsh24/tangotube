MeiliSearch::Rails.configuration = {
  meilisearch_host: Rails.application.credentials[Rails.env.to_sym].dig(:meilisearch, :host) || "http://127.0.0.1:7700",
  meilisearch_api_key: Rails.application.credentials[Rails.env.to_sym].dig(:meilisearch, :api_key) || nil
}
