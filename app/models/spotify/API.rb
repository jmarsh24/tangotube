# frozen_string_literal: true

module Spotify
  class API
    def initialize
      @client_id = Config.spotify_client_id!
      @client_secret = Config.spotify_secret_key!
      @token_uri = "https://accounts.spotify.com/api/token"
    end

    def access_token
      @access_token ||= begin
        options = {
          body: {grant_type: "client_credentials"},
          headers: {"Authorization" => "Basic #{credentials}"}
        }

        response = HTTParty.post(@token_uri, options)

        raise "Could not authenticate with Spotify" unless response.code == 200

        response.parsed_response["access_token"]
      end
    end

    private

    def credentials
      Base64.strict_encode64("#{@client_id}:#{@client_secret}")
    end
  end
end
