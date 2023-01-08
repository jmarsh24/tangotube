# frozen_string_literal: true

require "rails_helper"

RSpec.describe Video::MusicRecognition::AcrCloud do
  describe ".update_video" do
    it "updates video with acr_cloud response attributes" do
      VCR.use_cassette("video/music_recognition/acr_cloud") do
        video = create(:video, youtube_id: "s6iptZdCcG0")
        allow_any_instance_of(described_class).to receive(:audio_file_path).and_return("test/fixtures/s6iptZdCcG0_109_129.mp3")

        described_class.fetch("s6iptZdCcG0")
        video.reload

        expect(video.acr_response_code).to eq(0)
        expect(video.spotify_album_id).to be_nil
        expect(video.spotify_album_name).to be_nil
        expect(video.spotify_artist_id).to be_nil
        expect(video.spotify_artist_id_1).to be_nil
        expect(video.spotify_artist_id_2).to be_nil
        expect(video.spotify_artist_name).to be_nil
        expect(video.spotify_artist_name_1).to be_nil
        expect(video.spotify_artist_name_2).to be_nil
        expect(video.spotify_track_id).to be_nil
        expect(video.spotify_track_name).to be_nil
        expect(video.acr_cloud_artist_name).to eq("Osvaldo Pugliese")
        expect(video.acr_cloud_artist_name_1).to eq("Alberto Moran")
        expect(video.acr_cloud_album_name).to eq("Cantan Alberto Morán Y Roberto Chanel")
        expect(video.acr_cloud_track_name).to eq("La Mentirosa")
        expect(video.youtube_song_id).to be_nil
        expect(video.acrid).to eq("0d07891de1a0b282efce9b20dfce2bba")
        expect(video.isrc).to eq("ARF040200415")
      end
    end
  end
end
