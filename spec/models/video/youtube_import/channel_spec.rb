require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Video::YoutubeImport::Channel, type: :model do
  describe "#import" do
    it "creates new channel if missing" do
      yt_response = instance_double(Yt::Channel, id:            "valid_youtube_channel_id",
                                                 title:         "channel_title",
                                                 thumbnail_url: "channel_url",
                                                 video_count:   500)

      allow(Yt::Channel).to receive(:new).and_return(yt_response)

      expect { described_class.import("valid_youtube_channel_id") }.to change(Channel, :count).from(0).to(1)
    end

    it "imported channel has attributes" do
      yt_response = instance_double(Yt::Channel, id:            "valid_youtube_channel_id",
                                                 title:         "channel_title",
                                                 thumbnail_url: "channel_url",
                                                 video_count:   500)

      allow(Yt::Channel).to receive(:new).and_return(yt_response)

      described_class.import("valid_youtube_channel_id")
      channel = Channel.first
      expect(channel.channel_id).to eq("valid_youtube_channel_id")
      expect(channel.title).to eq("channel_title")
      expect(channel.thumbnail_url).to eq("channel_url")
      expect(channel.total_videos_count).to eq(500)
      expect(channel.imported?).to eq(false)
    end

    it "updates attributes if channel exists" do
      yt_response = instance_double(Yt::Channel, id:            "valid_youtube_channel_id",
                                                 title:         "channel_title",
                                                 thumbnail_url: "channel_url",
                                                 video_count:   500)

      allow(Yt::Channel).to receive(:new).and_return(yt_response)
      channel = create(:channel, channel_id: "valid_youtube_channel_id")

      described_class.import("valid_youtube_channel_id")
      channel.reload

      expect(channel.channel_id).to eq("valid_youtube_channel_id")
      expect(channel.title).to eq("channel_title")
      expect(channel.thumbnail_url).to eq("channel_url")
      expect(channel.total_videos_count).to eq(500)
      expect(channel.imported?).to eq(false)
    end
  end

  describe "#import_videos" do
    it "create import videos workers" do
      youtube_channel = described_class.new("ABC")
      youtube_channel.stub(:new_videos) { %w[video_id_1 video_id_2 video_id_3] }

      yt_response = instance_double(Yt::Channel, id:            "valid_youtube_channel_id",
                                                 title:         "channel_title",
                                                 thumbnail_url: "channel_url",
                                                 video_count:   3)

      allow(Yt::Channel).to receive(:new).and_return(yt_response)

      expect { youtube_channel.import_videos }.to change(ImportVideoWorker.jobs, :size).by(3)
    end
  end
end
