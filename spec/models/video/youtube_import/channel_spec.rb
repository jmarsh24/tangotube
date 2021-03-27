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
    end
  end

  describe "#import_videos" do
    it "#import_videos" do
      yt_response = instance_double(Yt::Channel, id:            "valid_youtube_channel_id",
                                                 title:         "channel_title",
                                                 thumbnail_url: "channel_url",
                                                 video_count:   3,
                                                 videos:        [build(:video, id: 1),
                                                                 build(:video, id: 2),
                                                                 build(:video, id: 3)])
      allow(Yt::Channel).to receive(:new).and_return(yt_response)

      expect { described_class.import_videos("valid_youtube_channel_id") }.to change(ImportVideoWorker.jobs, :size).by(3)
    end
  end
end

# expect(Channel.first.channel_id).to eq("valid_youtube_channel_id")
# expect(imported_channel.title).to eq("channel_title")
# expect(imported_channel.thumbnail_url).to eq("channel_url")
# expect(imported_channel.total_videos_count).to eq("channel_url")
# expect(imported_channel.videos).to eq(%w[youtube_video_id youtube_video_id1 youtube_video_id2])

#   describe "#fetch_by_id" do
#     it "returns true response" do
#       channel_id = "UCtdgMR0bmogczrZNpPaO66Q"
#       allow(described_class).to receive(:import).and_return
#       expect(described_class.fetch_by_id(channel_id)).to be true
#     end
#   end

#   describe "#channel" do
#     it "returns channel in database" do
#       channel_id = "UCtdgMR0bmogczrZNpPaO66Q"
#       youtube_channel = described_class.import("UCtdgMR0bmogczrZNpPaO66Q")
#       expect(youtube_channel.channel).to change(Channel, :count).from(0).to(1)
#     end
#   end
# end
# it "returns channel in database" do
#   create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
#   channel_id = "UCtdgMR0bmogczrZNpPaO66Q"
#   expect(described_class.channel).to change(Channel, :count).from(0).to(1)
# end

# it "creates a new channel" do
#   channel_id = "UCtdgMR0bmogczrZNpPaO66Q"
#   expect(described_class.import(channel_id)).to change(Channel, :count).from(0).to(1)
# end
