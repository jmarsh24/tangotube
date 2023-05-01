# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::DancerMatcher do
  fixtures :dancers

  describe "#match" do
    let(:metadata_fields) { ["Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"] }
    let(:dancer_matcher) { described_class.new }

    it "returns the best match for the given dancers" do
      expect(dancer_matcher.match(metadata_fields: metadata_fields)).to match_array([dancers(:carlitos), dancers(:noelia)])
    end

    it "returns an empty array when no match is found" do
      metadata_fields = ["Nonexistent Dancer", "Another Nonexistent Dancer", "Tango"]

      expect(dancer_matcher.match(metadata_fields: metadata_fields)).to eq([])
    end

    it "returns a match for partial names" do
      metadata_fields = ["Carlitos", "Noelia", "Tango"]

      expect(dancer_matcher.match(metadata_fields: metadata_fields)).to match_array([dancers(:carlitos), dancers(:noelia)])
    end

    it "returns a match for accented characters" do
      metadata_fields = ["Lorena Tarrantino", "Gianpiero Galdi", "Tango"]

      expect(dancer_matcher.match(metadata_fields: metadata_fields)).to match_array([dancers(:lorena), dancers(:gianpiero)])
    end
  end
end
