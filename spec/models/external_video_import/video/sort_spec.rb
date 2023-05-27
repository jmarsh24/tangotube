# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Sort do
  fixtures :all

  describe "#apply_sort" do
    context "when no sorting params are applied" do
      it "sorts by popularity in descending order" do
        sorted_videos = Video::Sort.new(Video.all).apply_sort

        expect(sorted_videos).to match_array(Video.all.order(popularity: :desc))
      end
    end
  end
end
