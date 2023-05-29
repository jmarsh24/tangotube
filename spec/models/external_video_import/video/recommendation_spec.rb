# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Recommendation do
  fixtures :all

  describe "#with_same_dancers" do
    it "returns videos with same leader and follower" do
      recommendation = described_class.new(videos(:video_1_featured))

      expect(recommendation.with_same_dancers).to match_array([videos(:video_4_featured)])
    end
  end
end
