require "rails_helper"

RSpec.describe Video::YoutubeImport::Channel, type: :model do
  describe "#import" do
    it "receives channel info from youtube" do
      channel = instance_double(:channel, channel_id:         "valid_youtube_channel_id",
                                          title:              "channel_title",
                                          thumbnail_url:      "channel_url",
                                          total_videos_count: 500,
                                          videos:             %w[youtube_video_id youtube_video_id1 youtube_video_id2])

      allow(Yt::Channel).to received(:new).and_return(channel)
      imported_channel = described_class.import("ABC")

      expect(imported_channel.channel_id).to eq("valid_youtube_channel_id")
      expect(imported_channel.title).to eq("channel_title")
      expect(imported_channel.thumbnail_url).to eq("channel_url")
      expect(imported_channel.total_videos_count).to eq("channel_url")
      expect(imported_channel.videos).to eq(%w[youtube_video_id youtube_video_id1 youtube_video_id2])
    end
  end
end

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
