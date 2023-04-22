# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioTrimmer do
  fixtures :all
  let(:audio_file) { file_fixture("audio.mp3").open }

  describe "#trim" do
    it "takes an audio file and creates a 20s snippet" do
      AudioTrimmer.new.trim(audio_file) do |trimmed_file|
        expect(FFMPEG::Movie.new(trimmed_file.path).duration.round).to eq 20
      end
    end
  end
end
