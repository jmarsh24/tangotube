# frozen_string_literal: true

class SpotifyArtistFinder
  def initialize
    @client_id = Config.spotify_client_id!
    @client_secret = Config.spotify_secret_key!
    @base_uri = "https://api.spotify.com/v1"
    @token_uri = "https://accounts.spotify.com/api/token"
  end

  def find(artist_id)
    response = HTTParty.get("#{@base_uri}/artists/#{artist_id}", headers:)

    case response.code
    when 200
      response.parsed_response
    when 401
      raise "Unauthorized - check your access token"
    when 404
      raise "Artist not found"
    else
      raise response
    end
  end

  private

  def headers
    {"Authorization" => "Bearer #{access_token}"}
  end

  def access_token
    @access_token ||= begin
      options = {
        body: {grant_type: "client_credentials"},
        headers: {"Authorization" => "Basic #{credentials}"}
      }

      response = HTTParty.post(@token_uri, options)

      if response.code == 200
        response.parsed_response["access_token"]
      else
        raise "Could not authenticate with Spotify"
      end
    end
  end

  def credentials
    Base64.strict_encode64("#{@client_id}:#{@client_secret}")
  end
end
