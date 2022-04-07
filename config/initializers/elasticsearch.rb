Elasticsearch::Model.client = Elasticsearch::Client.new url: env['RAILS_ENV']
Searchkick.client = Elasticsearch::Client.new(hosts: env['RAILS_ENV'], retry_on_failure: true, transport_options: {request: {timeout: 250} })
