# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioTrimmer do
  fixtures :all
  let(:audio_file) { file_fixture("audio.mp3").open }
  let(:audio_snippet) { file_fixture("audio_snippet.mp3") }

  describe "#trim" do
    it "takes an audio file and creates a 15s snippet" do
      AudioTrimmer.new.trim(audio_file) do |trimmed_file|
        expect(FFMPEG::Movie.new(trimmed_file.path).duration).to eq FFMPEG::Movie.new(audio_snippet.to_s).duration
        expect(File.extname(trimmed_file)).to eq ".mp3"
      end
    end
  end
end
