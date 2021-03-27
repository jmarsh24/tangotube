require "rails_helper"

RSpec.describe Video::YoutubeImport::Channel, type: :model do
  describe "#import" do
    it "receives response from youtube" do
      channel = create(:channel, channel_id: "UCtdgMR0bmogczrZNpPaO66Q")
      channel_id = channel.channel_id
      expect(described_class.import(channel_id)).to be true
    end
  end
end
