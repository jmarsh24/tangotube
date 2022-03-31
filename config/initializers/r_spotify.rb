if Rails.application.credentials.spotify[:client_id] && Rails.application.credentials.spotify[:secret_key]
  RSpotify.authenticate(Rails.application.credentials.spotify[:client_id], Rails.application.credentials.spotify[:secret_key])
end
