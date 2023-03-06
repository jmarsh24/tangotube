# frozen_string_literal: true

unless Rails.env.test?
   RSpotify.authenticate(Config.spotify_client_id!, Config.spotify_secret_key!)
 end
