if Rails.application.credentials.spotify[:client_id] && Rails.application.credentials.spotify[:secret_key]
  Rails.application.credentials.spotify[:client_id], Rails.application.credentials.spotify[:secret_key])
end
