url = Rails.application.credentials[Rails.env.to_sym].dig(:elasticsearch, :url) || "http://localhost:9200/"
Elasticsearch::Model.client = Elasticsearch::Client.new url: url
Searchkick.client = Elasticsearch::Client.new(hosts: url, retry_on_failure: true, transport_options: {request: {timeout: 250}})
