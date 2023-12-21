# frozen_string_literal: true

class Spotify
  SPOTIFY_API_URL = "https://api.spotify.com"
  SPOTIFY_ACCOUNTS_URL = "https://accounts.spotify.com/api/token"
  attr_accessor :user_id

  def initialize(client_id: Config.spotify_client_id!, client_secret: Config.spotify_secret_key!)
    @token = get_token(client_id:, client_secret:)
    @conn = Faraday.new do |conn|
      conn.request :authorization, "Bearer", "BQC6kHkFi-zb_0aKe3Ps8IfooWWUV1__DdV4rKYPbi22kGZB0KgyJHLfRhyb4tvMpgBHHj5KjKjtPjugkqxcONsCj5_VDUinkb4dFgFQPSwvXPFlfL1uvXyck19I7Q7LryOQEF4AGir29UbMZ_LgEhjw0NNRVkmF1fVUs7v2uJA9EL-DNwUriPnLB_oVXqn1-cGUfQchDS5js54FE9trrK98XBvwuz4TmAvn30VdIEgCfPg0YqE4yENPkEJjffvaVXwX"
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

  def get_album_cover_url(track_id)
    track_details = @conn.get("#{SPOTIFY_API_URL}/v1/tracks/#{track_id}").body

    album_id = track_details["album"]["id"]
    album_details = @conn.get("#{SPOTIFY_API_URL}/v1/albums/#{album_id}").body

    album_details["images"].first["url"]
  rescue Faraday::Error => e
    puts "Error retrieving album cover URL: #{e.message}"
    nil
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
