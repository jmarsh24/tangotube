# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::FuzzyText do
  let(:fuzzy_text) { described_class.new }
  let(:video_title) { "agustina piaggio carlitos espinoza ya lo vez darienzo maure by sivisart" }
  let(:song_title) { "ya lo ves" }
  let(:orchestra_name) { "darienzo" }

  describe "#jaro_winkler_score" do
    it "returns a high score for similar strings" do
      score = fuzzy_text.jaro_winkler_score(needle: song_title, haystack: video_title)
      expect(score).to be > 0.9
    end

    it "returns a low score for dissimilar strings" do
      score = fuzzy_text.jaro_winkler_score(needle: "Random String", haystack: video_title)
      expect(score).to be <= 0.6
    end
  end

  describe "#trigram_score" do
    it "returns a high score for similar strings" do
      score = fuzzy_text.trigram_score(needle: song_title, haystack: video_title)
      expect(score).to be > 0.8
    end

    it "returns a low score for dissimilar strings" do
      score = fuzzy_text.trigram_score(needle: "Random String", haystack: video_title)
      expect(score).to be <= 0.9
    end

    it "returns a high score for partial matches" do
      partial_match = orchestra_name.split(" ").first
      score = fuzzy_text.trigram_score(needle: partial_match, haystack: video_title)
      expect(score).to be > 0.8
    end
  end
end
