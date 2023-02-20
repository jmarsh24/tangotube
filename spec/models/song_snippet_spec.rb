# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongSnippet do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "create" do
    fit "returns the audio file from a slug", :vcr do
      song_snippet = File.open SongSnippet.create(slug).filepath
      expected_path = Rails.root.join "tmp/audio/video_AQ9Ri3kWa_4/AQ9Ri3kWa_4_snippet.mp3"
      expect(song_snippet.size).to eq 320926
      expect(song_snippet.path).to eq expected_path.to_s
    end
  end
end
