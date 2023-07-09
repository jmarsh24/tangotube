# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::SongInWrittenFormConverter do
  describe "#convert" do
    it "returns a string with the title, artist, and genre" do
      expect(described_class.new.convert("Milonga del 83")).to eq("milonga del ochenta y tres")
    end
  end
end
