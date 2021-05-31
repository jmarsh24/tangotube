require "rails_helper"

RSpec.describe Video::MusicRecognition, type: :model do
  describe ".from_youtube_id" do
    it "updates song attributes from youtube and acrcloud" do
      expect(Video::MusicRecognition::AcrCloud).to receive(:fetch).with("s6iptZdCcG0")
      expect(Video::MusicRecognition::Youtube).to receive(:fetch).with("s6iptZdCcG0")

      described_class.from_youtube_id("s6iptZdCcG0")
    end
  end
end
