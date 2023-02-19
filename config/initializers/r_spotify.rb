# frozen_string_literal: true

if ENV["INTERNET"]
  RSpotify.authenticate(Config.spotify_client_id!, Config.spotify_secret_key!)
end
