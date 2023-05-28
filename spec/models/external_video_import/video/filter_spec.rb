# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Filter do
  fixtures :all

  describe "#apply_filter" do
    subject { described_class.new(Video.all).apply_filter }

    context "when no filters are applied" do
      it "returns all videos" do
        expect(subject).to match_array(Video.all)
      end
    end

    context "when filtering by leader" do
      it "returns videos with leader" do
        filtered_videos = described_class.new(Video.all, filtering_params: {leader: "corina-herrera"}).apply_filter

        expect(filtered_videos).to match_array([videos(:video_5)])
      end
    end

    context "when filtering by follower" do
      it "returns videos with follower" do
        filtered_videos = described_class.new(Video.all, filtering_params: {follower: "corina-herrera"}).apply_filter

        expect(filtered_videos).to match_array([videos(:video_6)])
      end
    end

    context "when filtering by orchestra" do
      it "returns videos with orchestra" do
        filtered_videos = described_class.new(Video.all, filtering_params: {orchestra: "juan-darienzo"}).apply_filter

        expect(filtered_videos).to match_array([videos(:video_2_featured), videos(:video_3_featured), videos(:video_5)])
      end
    end

    context "when filtering by genre" do
      it "returns videos with genre" do
        filtered_videos = described_class.new(Video.all, filtering_params: {genre: "vals"}).apply_filter

        expect(filtered_videos).to match_array([videos(:video_4_featured)])
      end
    end

    context "when filtering by year" do
      it "returns videos with year" do
        filtered_videos = described_class.new(Video.all, filtering_params: {year: "2014"}).apply_filter

        expect(filtered_videos).to match_array([videos(:video_1_featured)])
      end
    end

    context "when filtering by song" do
      it "returns videos with song" do
        filtered_videos = described_class.new(Video.all, filtering_params: {song: "violetas-aberto-castillo"}).apply_filter

        expect(filtered_videos).to match_array([videos(:video_4_featured)])
      end
    end

    context "when filtering by follower, orchestra, and year" do
      it "returns videos with specified follower, orchestra, and year" do
        filtering_params = {follower: "corina-herrera", orchestra: "osvaldo-pugliese", year: "2018"}
        filtered_videos = described_class.new(Video.all, filtering_params:).apply_filter

        expect(filtered_videos).to match_array([videos(:video_6)])
      end
    end

    context "when filtering by leader, orchestra, genre, and year" do
      it "returns videos with specified leader, orchestra, genre, and year" do
        filtering_params = {leader: "corina-herrera", orchestra: "osvaldo-pugliese", genre: "tango", year: "2018"}
        filtered_videos = described_class.new(Video.all, filtering_params:).apply_filter

        expect(filtered_videos).to be_empty
      end
    end

    context "when filtering by leader, follower, orchestra, genre, year, and song" do
      it "returns videos with specified leader, follower, orchestra, genre, year, and song" do
        filtering_params = { leader: "octavio-fernandez", follower: "corina-herrera", orchestra: "osvaldo-pugliese", genre: "tango", year: "2018", song: "malandraca-osvaldo-pugliese" }
        filtered_videos = described_class.new(Video.all, filtering_params:).apply_filter

        expect(filtered_videos).to be_empty
      end
    end
  end
end
