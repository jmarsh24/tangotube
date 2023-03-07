# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioTrimmer do
  fixtures :all

  describe "download" do
    it "returns the video data from youtube and acrcloud" do
      audio_file = file_fixture("audio.mp3").open
      AudioTrimmer.new.trim(audio_file) do |trimmed_file|
        expect(trimmed_file.read).to eq file_fixture("audio_snippet.mp3").read
        expect(File.size(trimmed_file)).to eq 320926
        expect(File.extname(trimmed_file)).to eq ".mp3"
      end
    end
  end
end
