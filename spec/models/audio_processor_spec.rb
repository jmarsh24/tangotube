# frozen_string_literal: true

require "rails_helper"

RSpec.describe AudioProcessor do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "download" do
    it "returns the video data from youtube and acrcloud" do
      allow(AudioDownloader).to receive(:filepath).and_return(file_fixture("audio.mp3").to_path)
      snippet_filepath = AudioProcessor.process(slug:).filepath
      expected_filepath = Rails.root.join "tmp/audio/video_AQ9Ri3kWa_4/AQ9Ri3kWa_4_snippet.mp3"
      expect(snippet_filepath.to_s).to eq expected_filepath.to_s
      expect(File.size(snippet_filepath)).to eq 320926
      expect(File.extname(snippet_filepath)).to eq ".mp3"
      expect(File.exist?("/tmp/audio/video_#{slug}/#{slug}.mp3")).to be false
    end
  end
end
