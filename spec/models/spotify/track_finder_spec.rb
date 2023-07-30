# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spotify::TrackFinder do
  it "returns a track", :vcr do
    finder = Spotify::TrackFinder.new
    track = finder.search_track("la yumba osvaldo pugliese")
    expect(track).not_to be_nil
    expect(track.dig("id")).to eq("0tGPciWRMCp1o5P2YlSU79")
    expect(track.dig("name")).to eq("La Yumba")
  end
end
