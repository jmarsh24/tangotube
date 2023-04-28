# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::SongMatcher do
  fixtures :all
  let(:song) { songs(:nueve_de_julio) }

  describe "#match" do
    it "returns the best match" do
      metadata_fields = ["Juan D'Arienzo Nueve De Julio"]
      artist_fields = ["Juan D'Arienzo"]
      title_fields = ["Nueve De Julio"]
      song_matcher = described_class.new

      expect(song_matcher.match(artist_fields:, title_fields:, metadata_fields:)).to eq(song)
    end
  end
end
