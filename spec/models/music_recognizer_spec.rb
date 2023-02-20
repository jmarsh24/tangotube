# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:sound_file) { file_fixture("audio_snippet.mp3") }

  describe "recognize" do
    it "returns the music data from ACR Cloud and Spotify", vcr: { preserve_exact_body_bytes: true } do
      music_data = MusicRecognizer.process(sound_file:)
      expected_response = JSON.parse file_fixture("music_recognizer_data.json").read
      expect(music_data).to eq expected_response
    end
  end
end
