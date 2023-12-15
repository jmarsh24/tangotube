# frozen_string_literal: true

class Spotify
  SPOTIFY_API_URL = "https://api.spotify.com"
  SPOTIFY_ACCOUNTS_URL = "https://accounts.spotify.com/api/token"
  attr_accessor :user_id

  def initialize(client_id: Config.spotify_client_id!, client_secret: Config.spotify_secret_key!)
    @token = get_token(client_id:, client_secret:)
    @conn = Faraday.new do |conn|
      conn.request :authorization, "Bearer", "BQCD1GTqkKuP0-lyps5fyQaXdWRk2owHJQBqwU27BAIrtpSLIObzzT4ajDBSVswtikgleO7AzIk4ZWeNVUL5exCYuVsG_RhG0tbw0pcLll9DqUZjjZxbaVmEvPMDJZW31bhVyGQdf06e4NIBiOKXQBsYsz_n--H5nw6cLXJ79Gg2CahXartrS-6Wi2TmR-CkB6YBF9ar0a9_iuaP5Zn-VR36xxnkbHpXFUKpDZANSTuvVmqU9HU9M5kO-AKCsjgGMs8Y"
      conn.request :json
      conn.response :json
      conn.response :raise_error
    end
  end

  def add_tracks_to_playlist(playlist_id:, track_ids:)
    track_uris = track_ids.map { |id| "spotify:track:#{id}" }

    url = "#{SPOTIFY_API_URL}/v1/playlists/#{playlist_id}/tracks"
    payload = {uris: track_uris}

    @conn.post(url, payload)
  rescue Faraday::Error => e
    puts "Error adding tracks to playlist: #{e.message}"
  end

  private

  def get_token(client_id:, client_secret:)
    credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")

    response = Faraday.post(SPOTIFY_ACCOUNTS_URL) do |req|
      req.headers["Authorization"] = "Basic #{credentials}"
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = "grant_type=client_credentials"
    end

    response.body["access_token"]
  rescue Faraday::Error => e
    puts "Error retrieving token: #{e.message}"
    nil
  end
end
