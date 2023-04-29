# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::SongMatcher do
  fixtures :all
  let(:song) { songs(:nueve_de_julio) }
  let(:accented_song) { songs(:cafe_dominguez) }
  let(:song_matcher) { described_class.new }

  describe "#match" do
    context "when the song exists" do
      let(:metadata_fields) { ["Juan D'Arienzo Nueve De Julio"] }
      let(:artist_fields) { ["Juan D'Arienzo"] }
      let(:title_fields) { ["Nueve De Julio"] }

      it "returns the best match" do
        expect(song_matcher.match(artist_fields: artist_fields, title_fields: title_fields, metadata_fields: metadata_fields, genre: nil)).to eq(song)
      end
    end

    context "when the song does not exist" do
      let(:metadata_fields) { ["Juan Villareal Milonga Del Don"] }
      let(:artist_fields) { ["Juan Villarreal"] }
      let(:title_fields) { ["Milonga Del Don"] }

      it "returns a newly created song" do
        expect(song_matcher.match(artist_fields: artist_fields, title_fields: title_fields, metadata_fields: metadata_fields, genre: nil)).to eq(::Song.last)
      end
    end

    context "when metadata has a mix of artist and title fields" do
      let(:metadata_fields) { ["Nueve De Julio by Juan D'Arienzo"] }
      let(:artist_fields) { ["Juan D'Arienzo"] }
      let(:title_fields) { ["Nueve De Julio"] }

      it "returns the best match" do
        expect(song_matcher.match(artist_fields: artist_fields, title_fields: title_fields, metadata_fields: metadata_fields, genre: nil)).to eq(song)
      end
    end

    context "when the threshold is not met" do
      let(:metadata_fields) { ["Some unrelated metadata"] }
      let(:artist_fields) { ["Nonexistent Artist"] }
      let(:title_fields) { ["Nonexistent Title"] }

      it "returns a newly created song" do
        expect(song_matcher.match(artist_fields: artist_fields, title_fields: title_fields, metadata_fields: metadata_fields, genre: nil)).to eq(::Song.last)
      end
    end

    context "when metadata contains accented characters" do
      let(:metadata_fields) { ["José García Café Dominguez"] }
      let(:artist_fields) { ["José García"] }
      let(:title_fields) { ["Café Dominguez"] }

      it "returns the best match" do
        expect(song_matcher.match(artist_fields: artist_fields, title_fields: title_fields, metadata_fields: metadata_fields, genre: nil)).to eq(accented_song)
      end
    end
  end
end
