# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::Trigram do
  let(:items) { ["Pepito Avellaneda & Tete Rusconi", "Carlos Gavito & Marcela Durán", "Geraldine Rojas & Ezequiel Paludi"] }

  describe "#similarity" do
    it "returns the best matches for the given list" do
      text = "Pepito Avellaneda y Tete Rusconi - Tango"
      similarity_ratio = items.map { |item| described_class.new(text).similarity(item) }.max

      expect(similarity_ratio).to be > 0.8
    end

    it "returns 0 when no match is found" do
      text = "Random dancers - Tango"
      similarity_ratio = items.map { |item| described_class.new(text).similarity(item) }.max

      expect(similarity_ratio).to eq(0)
    end

    it "returns a non-zero match for partial names" do
      text = "Pepito & Tete - Tango"
      similarity_ratio = items.map { |item| described_class.new(text).similarity(item) }.max

      expect(similarity_ratio).to be > 0
    end

    it "returns a non-zero match for accented characters" do
      items_with_accents = ["Martín Maldonado & Maurizio Ghella", "Esteban Cortez & Evelyn Rivera", "Gustavo Naveira & Giselle Anne"]
      text = "Martín Maldonado y Maurizio Ghella - Tango"
      similarity_ratio = items_with_accents.map { |item| described_class.new(text).similarity(item) }.max

      expect(similarity_ratio).to be > 0.8
    end
  end
end
