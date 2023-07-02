# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::DancerMatcher do
  fixtures :all

  describe "#match" do
    let(:dancer_matcher) { described_class.new }

    it "returns the best match for the given dancers" do
      video_title = "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(dancer_matcher.match(video_title:)).to match_array([dancers(:carlitos), dancers(:noelia)])
    end

    it "returns an empty array when no match is found" do
      video_title = "Nonexistent Dancer Another Nonexistent Dancer Tango"

      expect(dancer_matcher.match(video_title:)).to eq([])
    end

    it "returns a match for accented characters" do
      video_title = "Lorena Tarrantino Gianpiero Galdi Tango"

      expect(dancer_matcher.match(video_title:)).to match_array([dancers(:lorena), dancers(:gianpiero)])
    end

    it "does not find an incorrect match" do
      video_title = "Vanesa Villalba and Facundo Pinero - Tu Voz"

      expect(dancer_matcher.match(video_title:)).to match_array([dancers(:facundo), dancers(:vanessa)])
      expect(dancer_matcher.match(video_title:)).not_to include(dancers(:facundo_gil))
    end
  end
end
