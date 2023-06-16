# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::Filter do
  fixtures :all

  describe "#filtered_videos" do
    subject { described_class.new(Video.all).filtered_videos }

    context "when no filters are applied" do
      it "returns all videos" do
        expect(subject).to match_array(Video.all)
      end
    end

    context "when filtering by leader and follower" do
      it "returns videos with specified leader and follower" do
        filtering_params = {leader: "carlitos-espinoza", follower: "noelia-hurtado"}
        filtered_videos = described_class.new(Video.all, filtering_params:).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_1_featured), videos(:video_4_featured)])
      end
    end

    context "when filtering by leader" do
      it "returns videos with leader" do
        filtered_videos = described_class.new(Video.all, filtering_params: {leader: "corina-herrera"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_5)])
      end
    end

    context "when filtering by follower" do
      it "returns videos with follower" do
        filtered_videos = described_class.new(Video.all, filtering_params: {follower: "corina-herrera"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_6)])
      end
    end

    context "when filtering by orchestra" do
      it "returns videos with orchestra" do
        filtered_videos = described_class.new(Video.all, filtering_params: {orchestra: "juan-darienzo"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_2_featured), videos(:video_3_featured), videos(:video_5)])
      end
    end

    context "when filtering by genre" do
      it "returns videos with genre" do
        filtered_videos = described_class.new(Video.all, filtering_params: {genre: "vals"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_4_featured)])
      end
    end

    context "when filtering by year" do
      it "returns videos with year" do
        filtered_videos = described_class.new(Video.all, filtering_params: {year: "2014"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_1_featured)])
      end
    end

    context "when filtering by song" do
      it "returns videos with song" do
        filtered_videos = described_class.new(Video.all, filtering_params: {song: "violetas-aberto-castillo"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_4_featured)])
      end
    end

    context "when filtering by follower, orchestra, and year" do
      it "returns videos with specified follower, orchestra, and year" do
        filtering_params = {follower: "corina-herrera", orchestra: "osvaldo-pugliese", year: "2018"}
        filtered_videos = described_class.new(Video.all, filtering_params:).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_6)])
      end
    end

    context "when filtering by leader, follower, orchestra, genre, year, and song" do
      it "returns videos with specified leader, follower, orchestra, genre, year, and song" do
        filtering_params = {leader: "octavio-fernandez", follower: "corina-herrera", orchestra: "osvaldo-pugliese", genre: "tango", year: "2018", song: "malandraca-osvaldo-pugliese"}
        filtered_videos = described_class.new(Video.all, filtering_params:).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_6)])
      end
    end

    context "when filtering by liked_by_user" do
      it "returns videos liked by user" do
        current_user = users(:regular)
        video = videos(:video_1_featured)
        video.upvote_by current_user, vote_scope: "like"

        filtered_videos = described_class.new(Video.all, filtering_params: {liked: true}, current_user:).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_1_featured)])
      end
    end

    context "when filtering by watched_by_user" do
      it "returns videos watched by user" do
        user = users(:regular)
        video = videos(:video_1_featured)

        Watch.create(user:, video:)

        filtered_videos = described_class.new(Video.all, filtering_params: {watched: true}, current_user: user).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_1_featured)])
      end
    end

    context "when filtering by query" do
      it "returns videos matching query" do
        Video.find_in_batches.each { |e| Video.index!(e.map(&:id), now: true) }

        filtered_videos = described_class.new(Video.all, filtering_params: {search: "carlitoss"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_1_featured), videos(:video_4_featured)])
      end

      it "returns videos matching query with accents" do
        Video.find_in_batches.each { |e| Video.index!(e.map(&:id), now: true) }

        filtered_videos = described_class.new(Video.all, filtering_params: {search: "carlíitos"}).filtered_videos

        expect(filtered_videos).to match_array([videos(:video_1_featured), videos(:video_4_featured)])
      end

      it "returns videos matching query with a ' character" do
        Video.find_in_batches.each { |e| Video.index!(e.map(&:id), now: true) }

        filtered_videos = described_class.new(Video.all, filtering_params: {search: "darienzo"}).filtered_videos
        expect(filtered_videos).to match_array([videos(:video_2_featured), videos(:video_3_featured), videos(:video_5)])
      end
    end
  end
end