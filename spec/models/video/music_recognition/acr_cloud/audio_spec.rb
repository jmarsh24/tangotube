# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::MusicRecognition::AcrCloud::Audio do
  describe ".import" do
    it "returns object with correct file path" do
      allow_any_instance_of(described_class).to receive(:fetch_audio_from_youtube).and_return("test/fixtures/s6iptZdCcG0.mp3")

      expect(described_class.import("s6iptZdCcG0")).to eq("test/fixtures/s6iptZdCcG0.mp3")
    end
  end
end
