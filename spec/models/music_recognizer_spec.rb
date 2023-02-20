# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusicRecognizer do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "recognize" do
    it "returns the music data from ACR Cloud and Spotify", vcr: {preserve_exact_body_bytes: true} do
      music_metadata = MusicRecognizer.process(slug:).metadata
      expected_response = JSON.parse file_fixture("music_recognizer_data.json").read
      expect(File.exist?("/tmp/audio/video_#{slug}/#{slug}_snippet.mp3")).to be false
      expect(music_metadata).to eq expected_response
    end
  end
end
