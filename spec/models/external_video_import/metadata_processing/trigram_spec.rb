# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::Trigram do
  let(:items) { ["Pepito Avellaneda & Tete Rusconi", "Carlos Gavito & Marcela Durán", "Geraldine Rojas & Ezequiel Paludi"] }
  let(:text) { "Pepito Avellaneda y Tete Rusconi - Tango" }
  let(:threshold) { 0.6 }

  describe "#best_matches" do
    it "returns the best matches for the given list" do
      best_matches = described_class.best_matches(list: items, text: text, threshold: threshold) { |item| item }

      expect(best_matches).to eq([[items[0], 0.9642857142857143]])
    end

    it "returns an empty array when no match is found" do
      text = "Random dancers - Tango"
      best_matches = described_class.best_matches(list: items, text: text, threshold: threshold) { |item| item }

      expect(best_matches).to eq([])
    end

    it "returns a match for partial names" do
      text = "Pepito & Tete - Tango"
      best_matches = described_class.best_matches(list: items, text: text, threshold: threshold) { |item| item }

      expect(best_matches).to eq([])
    end

    it "returns a match for accented characters" do
      items_with_accents = ["Martín Maldonado & Maurizio Ghella", "Esteban Cortez & Evelyn Rivera", "Gustavo Naveira & Giselle Anne"]
      text = "Martín Maldonado y Maurizio Ghella - Tango"
      best_matches = described_class.best_matches(list: items_with_accents, text: text, threshold: threshold) { |item| item }

      expect(best_matches).to eq([[items_with_accents[0], 0.9333333333333333]])
    end
  end
end
