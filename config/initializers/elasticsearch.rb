Searchkick.client = Elasticsearch::Client.new(hosts: ["localhost:9200"], retry_on_failure: true, transport_options: {request: {timeout: 250}})
