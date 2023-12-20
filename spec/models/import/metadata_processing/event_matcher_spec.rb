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

    it "matches event properly" do
      video_title = "Bruno Tombari y Rocío Lequio Tears in heaven Frederik Konradsen"
      video_description = "Bruno Tombari y Rocío Lequio Tears in heaven, Frederik Konradsen Scala, TipoTango, 4D Tango festival May 6th 2016, Eindhoven, Video: Wim Reumers"
      torino_festival = Event.create!(title: "Tango Torino Festival", city: "Torino", country: "Italy")

      expect(event_matcher.match(video_title:, video_description:)).not_to eq torino_festival
    end
  end
end
