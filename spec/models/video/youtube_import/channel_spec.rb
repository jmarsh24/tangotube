require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Video::YoutubeImport::Channel, type: :model do
  describe "#import" do
    it "creates new channel if missing" do
      VCR.use_cassette("video/youtubeimport/channel") do
        expect{described_class.import("UC9lGGipk4wth0rDyy4419aw")}.to change(Channel, :count).from(0).to(1)
        channel = Channel.find_by(channel_id: "UC9lGGipk4wth0rDyy4419aw")
        expect(channel.channel_id).to eq("UC9lGGipk4wth0rDyy4419aw")
        expect(channel.thumbnail_url).to eq("https://yt3.ggpht.com/ytc/AAUvwnjGYCOkZDPgEinTJCtfCH5iwBR4w3YPVYwNOg=s88-c-k-c0x00ffffff-no-rj")
        expect(channel.imported).to eq(false)
        expect(channel.imported_videos_count).to eq(0)
        expect(channel.total_videos_count).to eq(5)
        expect(channel.videos_count).to eq(0)
        expect(channel.yt_api_pull_count).to eq(0)
      end
    end

    it "updates channel information if channel already exists" do
      VCR.use_cassette("video/youtubeimport/channel") do
        channel = create(:channel, channel_id: "UC9lGGipk4wth0rDyy4419aw")
        expect(Channel.count).to eq(1)
        expect{described_class.import("UC9lGGipk4wth0rDyy4419aw")}.not_to change(Channel, :count)
        channel.reload

        expect(channel.channel_id).to eq("UC9lGGipk4wth0rDyy4419aw")
        expect(channel.thumbnail_url).to eq("https://yt3.ggpht.com/ytc/AAUvwnjGYCOkZDPgEinTJCtfCH5iwBR4w3YPVYwNOg=s88-c-k-c0x00ffffff-no-rj")
        expect(channel.imported).to eq(false)
        expect(channel.imported_videos_count).to eq(0)
        expect(channel.total_videos_count).to eq(5)
        expect(channel.videos_count).to eq(0)
        expect(channel.yt_api_pull_count).to eq(0)
      end
    end
  end

  describe "#import_videos" do
    it "import all videos" do
      VCR.use_cassette("video/youtubeimport/channel_videos") do
        expect{described_class.import("UC9lGGipk4wth0rDyy4419aw")}.to change(Channel, :count).from(0).to(1)

        expect{described_class.import_videos("UC9lGGipk4wth0rDyy4419aw")}.to change(ImportVideoWorker.jobs, :size).by(5)
      end
    end

    it "imports only new videos" do
      VCR.use_cassette("video/youtubeimport/channel_videos") do
        channel = create(:channel, channel_id: "UC9lGGipk4wth0rDyy4419aw")
        expect{described_class.import("UC9lGGipk4wth0rDyy4419aw")}.not_to change(Channel, :count)
        create(:video, youtube_id: "s8olH-kdwzw", channel: channel)

        expect{described_class.import_videos("UC9lGGipk4wth0rDyy4419aw")}.to change(ImportVideoWorker.jobs, :size).by(4)
      end
    end

    it "doesn't import new videos" do
      VCR.use_cassette("video/youtubeimport/channel_videos") do
        channel = create(:channel, channel_id: "UC9lGGipk4wth0rDyy4419aw")
        create(:video, youtube_id: "s8olH-kdwzw", channel: channel)
        create(:video, youtube_id: "M50x-wkXZHI", channel: channel)
        create(:video, youtube_id: "s9XsU3w7MtQ", channel: channel)
        create(:video, youtube_id: "xMuN6myb2eQ", channel: channel)
        create(:video, youtube_id: "Iyl-PPdB4XU", channel: channel)

        expect{described_class.import("UC9lGGipk4wth0rDyy4419aw")}.not_to change(Channel, :count)

        expect{described_class.import_videos("UC9lGGipk4wth0rDyy4419aw")}.not_to change(ImportVideoWorker.jobs, :size)
      end
    end
  end
end
