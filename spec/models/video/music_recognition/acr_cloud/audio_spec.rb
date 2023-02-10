# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::MusicRecognition::AcrCloud::Audio do
  describe ".import" do
    it "returns object with correct file path" do
      audio_fetch = Video::MusicRecognition::AcrCloud::Audio.new "s6iptZdCcG0", file_fixture("audio.mp3").to_s
      allow(audio_fetch).to receive(:fetch_audio_from_youtube).and_return(file_fixture("audio.mp3").to_s)
      expect(audio_fetch.import).to be_truthy
    end
  end
end
