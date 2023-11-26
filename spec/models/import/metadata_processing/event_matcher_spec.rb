# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::MetadataProcessing::EventMatcher do
  fixtures :all
  let(:event_matcher) { described_class.new }

  describe "#match" do
    it "returns an empty array" do
      video_title = "Nonexistent Event"
      video_description = "Nonexistent Event"

      expect(event_matcher.match(video_title:, video_description:)).to be_nil
    end

    it "returns the best match" do
      video_title = "Krakus Aires Tango"
      video_description = "Krakus Aires Tango Festival"
      expected_event = events :krakus_aires_tango_festival

      expect(event_matcher.match(video_title:, video_description:)).to eq expected_event
    end
  end
end
