if Rails.env == "production"
  url = 'https://f4nmzumvzb:2fj6pcm3vk@tangotube-production-7618181255.eu-central-1.bonsaisearch.net:443'
    Elasticsearch::Model.client = Elasticsearch::Client.new url: url
  Searchkick.client = Elasticsearch::Client.new(hosts: url, retry_on_failure: true, transport_options: {request: {timeout: 250}})
else
  url = 'http://localhost:9200/'
    Elasticsearch::Model.client = Elasticsearch::Client.new url: url
  Searchkick.client = Elasticsearch::Client.new(hosts: url, retry_on_failure: true, transport_options: {request: {timeout: 250}})
end
