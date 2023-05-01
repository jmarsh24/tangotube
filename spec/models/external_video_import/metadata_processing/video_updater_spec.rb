# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::VideoUpdater, type: :model do
  fixtures :videos
  let(:video) { videos(:video_1_featured) }
  let(:metadata) do
    ExternalVideoImport::Metadata.new(
      youtube: ExternalVideoImport::Youtube::VideoMetadata.new(
        slug: "test_video_slug",
        title: "Carlitos Espinoza & Noelia Hurtado - Nueve de Julio - Tango 3 / 5",
        description: "Test video description featuring amazing dancers and great music.",
        upload_date: "2022-01-01",
        duration: 180,
        tags: ["tag1", "tag2"],
        hd: true,
        view_count: 1000,
        favorite_count: 100,
        comment_count: 50,
        like_count: 200,
        song: ExternalVideoImport::Youtube::SongMetadata.new(
          titles: ["Song Title 1", "Song Title 2"],
          song_url: "https://example.com/song-url",
          artist: "Artist Name",
          artist_url: "https://example.com/artist-url",
          writers: ["Writer 1", "Writer 2"],
          album: "Album Name"
        ),
        thumbnail_url: ExternalVideoImport::Youtube::ThumbnailUrl.new(
          default: "default_url",
          medium: "medium_url",
          high: "high_url",
          standard: "standard_url",
          maxres: "maxres_url"
        ),
        recommended_video_ids: ["video_id_1", "video_id_2"],
        channel: {
          id: "UCtdgMR0bmogczrZNpPaO66Q",
          title: "030Tango"
        }
      ),
      music: ExternalVideoImport::MusicRecognition::Metadata.new(
        acr_song_title: "Nueve de Julio",
        acr_artist_names: ["Juan D'Arienzo", "Artist 2"],
        acr_album_name: "Album 1",
        acr_id: "acr_id_1",
        isrc: "isrc_1",
        genre: "Genre 1",
        spotify_artist_names: ["Spotify Artist 1", "Spotify Artist 2"],
        spotify_track_name: "Spotify Song 1",
        spotify_track_id: "6wcryUdE3GbVVnuBFE6Zmv",
        spotify_album_name: "Spotify Album 1",
        spotify_album_id: "spotify_album_id_1",
        youtube_vid: "youtube_vid_1"
      )
    )
  end
  subject { described_class.new(video) }

  describe "#update" do
    it "updates the video with the provided metadata" do
      expect(video).to receive(:update!).with(metadata: metadata)
      expect_any_instance_of(ExternalVideoImport::MetadataProcessing::ThumbnailAttacher).to receive(:attach_thumbnail)

      subject.update(metadata)
    end

    it "logs an error and raises an exception if the video update fails" do
      allow(video).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      allow(Rails.logger).to receive(:error)

      expect {
        subject.update(metadata)
      }.to raise_error(ExternalVideoImport::VideoUpdateError)

      expect(Rails.logger).to have_received(:error).once
    end
  end
end
