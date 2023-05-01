# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::EventMatcher do
  fixtures :events
  let(:event_matcher) { described_class.new }

  describe "#match" do
    context "when there is no match" do
      let(:metadata_fields) { ["Nonexistent Event"] }

      it "returns an empty array" do
        expect(event_matcher.match(metadata_fields: metadata_fields)).to be_nil
      end
    end

    context "when there are multiple matches" do
      let(:metadata_fields) { ["Bailemo Tango Festival"] }
      let(:expected_event) { events(:bailemos_tango_festival) }

      it "returns the best match with the highest similarity ratio" do
        expect(event_matcher.match(metadata_fields: metadata_fields)).to eq(expected_event)
      end
    end

    context "when there is one match" do
      let(:metadata_fields) { ["Krakus Aires Tango"] }
      let(:expected_event) { events(:krakus_aires_tango_festival) }

      it "returns the best match" do
        expect(event_matcher.match(metadata_fields: metadata_fields)).to eq(expected_event)
      end
    end
  end
end
