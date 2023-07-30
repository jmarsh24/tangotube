# frozen_string_literal: true

module Spotify
  class ArtistFinder
    def initialize
      @base_uri = "https://api.spotify.com/v1"
      @api = Spotify::API.new
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
      {"Authorization" => "Bearer #{@api.access_token}"}
    end
  end
end
