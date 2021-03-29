require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Video::YoutubeImport::Playlist, type: :model do
  describe "#import" do
    it "creates new playlist if missing" do
      yt_response = instance_double(Yt::Playlist, id:             "valid_youtube_playlist_id",
                                                  title:          "playlist_title",
                                                  description:    "playlist_description",
                                                  channel_id:     "channel_id",
                                                  channel_title:  "channel_title",
                                                  playlist_items: %w[1 2 3])

      allow(Yt::Playlist).to receive(:new).and_return(yt_response)

      expect { described_class.import("valid_youtube_playlist_id") }.to change(Playlist, :count).from(0).to(1)
    end

    it "imported playlist has attributes" do
      yt_response = instance_double(Yt::Playlist, id:             "valid_youtube_playlist_id",
                                                  title:          "playlist_title",
                                                  description:    "playlist_description",
                                                  channel_id:     "channel_id",
                                                  channel_title:  "channel_title",
                                                  playlist_items: %w[1 2 3])

      allow(Yt::Playlist).to receive(:new).and_return(yt_response)

      described_class.import("valid_youtube_playlist_id")
      playlist = Playlist.first

      expect(playlist.slug).to eq("valid_youtube_playlist_id")
      expect(playlist.title).to eq("playlist_title")
      expect(playlist.description).to eq("playlist_description")
      expect(playlist.channel_id).to eq("channel_id")
      expect(playlist.channel_title).to eq("channel_title")
      expect(playlist.video_count).to eq("3")
      expect(playlist.imported?).to eq(false)
    end
  end

  describe "#import_videos" do
    it "creates import videos worker" do
      youtube_playlist = described_class.new("ABC")
      youtube_playlist.stub(:new_videos) { %w[video_id_1 video_id_2 video_id_3] }

      yt_response = instance_double(Yt::Playlist, id:            "valid_youtube_playlist_id",
                                                  title:         "playlist_title",
                                                  description:   "playlist_description",
                                                  channel_id:    "channel_id",
                                                  channel_title: "channel_title")

      allow(Yt::Playlist).to receive(:new).and_return(yt_response)

      expect { youtube_playlist.import_videos }.to change(ImportVideoWorker.jobs, :size).by(3)
    end
  end

  describe "#import_channels" do
    it "creates import channels worker" do
      youtube_playlist = described_class.new("ABC")
      youtube_playlist.stub(:new_channels) { %w[video_id_1 video_id_2 video_id_3] }

      yt_response = instance_double(Yt::Playlist, id:            "valid_youtube_playlist_id",
                                                  title:         "playlist_title",
                                                  description:   "playlist_description",
                                                  channel_id:    "channel_id",
                                                  channel_title: "channel_title")

      allow(Yt::Playlist).to receive(:new).and_return(yt_response)

      expect { youtube_playlist.import_channels }.to change(ImportChannelWorker.jobs, :size).by(3)
    end
  end
end
