require "rails_helper"

RSpec.describe Video::MusicRecognition::AcrCloud::Audio, type: :model do
    describe ".import" do
    it "updates existing record" do
        allow_any_instance_of(described_class).to receive(:youtube_audio_file_path).and_return("test/fixtures/s6iptZdCcG0.mp3")

        expect(described_class.import("s6iptZdCcG0").path).to eq("test/fixtures/s6iptZdCcG0_109_129.mp3")
    end
  end
end
