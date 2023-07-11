# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpotifyArtistFinder do
  describe "#find" do
    it "returns the artist genres", :vcr do
      artist_id = "10exVja0key0uqUkk6LJRT"

      expect(SpotifyArtistFinder.new.find(artist_id).dig("genres")).to eq ["folk-pop", "modern rock"]
    end
  end
end
