# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spotify::ArtistFinder do
  it "returns an artist", :vcr do
    finder = Spotify::ArtistFinder.new
    artist = finder.find("2HO9rAU2R7CRnmhx0ytN41")
    expect(artist).not_to be_nil
    expect(artist.dig("name")).to eq("Osvaldo Pugliese")
  end
end
