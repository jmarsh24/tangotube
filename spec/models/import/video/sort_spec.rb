# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Sort do
  fixtures :all

  describe "#sorted_videos" do
    context "when sorting by upload_date in ascending order" do
      it "sorts the videos by upload date in ascending order" do
        sorted_videos = Video::Sort.new(Video.all, sort: "oldest").videos

        expect(sorted_videos).to eq(Video.all.order(upload_date: :asc))
      end
    end

    context "when sorting by song title in ascending order" do
      it "sorts the videos by song title in ascending order" do
        sorted_videos = Video::Sort.new(Video.all, sort: "song").videos

        expect(sorted_videos).to eq(Video.all.joins(:song).order("songs.title": :asc))
      end
    end

    context "when sorting by orchestra in descending order" do
      it "sorts the videos by orchestra in descending order" do
        sorted_videos = Video::Sort.new(Video.all, sort: "orchestra").videos

        expect(sorted_videos).to eq(Video.all.joins(song: :orchestra).order("orchestras.name": :asc))
      end
    end

    context "when sorting by performance in ascending order" do
      it "sorts the videos by performance" do
        sorted_videos = Video::Sort.new(Video.all, sort: "performance").videos

        expect(sorted_videos).to eq(Video.all.joins(:performance_video).order("performance_videos.position": :asc))
      end
    end
  end
end
