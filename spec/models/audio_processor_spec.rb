# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioProcessor do
  fixtures :all
  let(:audio_filepath) { file_fixture("audio.mp3").to_s }

  describe "download" do
    it "returns the video data from youtube and acrcloud" do
      snippet_filepath = AudioProcessor.process(audio_filepath).snippet_filepath

      expect(snippet_filepath.to_s).to eq "spec/fixtures/files/audio_snippet.mp3"
      expect(File.size(snippet_filepath)).to eq 320926
      expect(File.extname(snippet_filepath)).to eq ".mp3"
    end
  end
end
