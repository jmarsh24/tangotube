# frozen_string_literal: true

module Spotify
  class TrackFinder
    def initialize
      @base_uri = "https://api.spotify.com/v1"
      @api = Spotify::API.new
    end

    def search_track(name)
      response = HTTParty.get("#{@base_uri}/search", query: {q: name, type: "track", limit: 1}, headers:)

      case response.code
      when 200
        response.parsed_response.dig("tracks", "items", 0)
      when 401
        raise "Unauthorized - check your access token"
      else
        raise response
      end
    end

    private

    def headers
      {"Authorization" => "Bearer #{@api.access_token}"}
    end
  end
end
