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

    context "when sorting by upload_date in ascending order" do
      it "sorts the videos by upload date in ascending order" do
        sorted_videos = Video::Sort.new(Video.all, sorting_params: {sort: "upload_date", direction: "asc"}).apply_sort

        expect(sorted_videos).to match_array(Video.all.order(upload_date: :asc))
      end
    end

    context "when sorting by song title in ascending order" do
      it "sorts the videos by song title in ascending order" do
        sorted_videos = Video::Sort.new(Video.all, sorting_params: {sort: "song", direction: "asc"}).apply_sort

        expect(sorted_videos).to match_array(Video.all.joins(:song).order("songs.title": :asc))
      end
    end

    context "when sorting by orchestra in descending order" do
      it "sorts the videos by orchestra in descending order" do
        sorted_videos = Video::Sort.new(Video.all, sorting_params: {sort: "orchestra", direction: "desc"}).apply_sort

        expect(sorted_videos).to match_array(Video.all.joins(song: :orchestra).order("orchestras.name DESC"))
      end
    end

    context "when sorting by performance in ascending order" do
      it "sorts the videos by performance" do
        sorted_videos = Video::Sort.new(Video.all, sorting_params: {sort: "performance", direction: "desc"}).apply_sort

        expect(sorted_videos).to match_array(Video.all.joins(:performance_video).order("performance_videos.performance_id ASC"))
      end
    end
  end
end
