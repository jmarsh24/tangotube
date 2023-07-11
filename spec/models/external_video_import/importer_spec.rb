# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Importer do
  fixtures :all

  let(:video_crawler) { ExternalVideoImport::Crawler.new }
  let(:metadata_processor) { ExternalVideoImport::MetadataProcessing::MetadataProcessor.new }
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

  let(:processed_metadata) do
    {youtube_id: "test_video_slug",
     upload_date: Date.parse("01 Jan 2022"),
     upload_date_year: 2022,
     title: "Carlitos Espinoza & Noelia Hurtado - Nueve de Julio - Tango 3 / 5",
     description: "Test video description featuring amazing dancers and great music.",
     channel: channels(:"030tango"),
     song: songs(:nueve_de_julio),
     couples: [couples(:carlitos_noelia)],
     acr_response_code: nil,
     duration: 180,
     hd: true,
     youtube_view_count: 1000,
     youtube_like_count: 200,
     youtube_tags: ["tag1", "tag2"],
     dancer_videos: [
       DancerVideo.new(dancer_id: 839919117, role: "leader"),
       DancerVideo.new(dancer_id: 467770177, role: "follower")
     ]}
  end

  let(:importer) do
    described_class.new(
      video_crawler:,
      metadata_processor:
    )
  end

  before do
    allow(video_crawler).to receive(:metadata).with("test_video_slug", use_scraper: false, use_music_recognizer: false).and_return(metadata)
    allow(metadata_processor).to receive(:process).with(metadata).and_return(processed_metadata)
  end

  describe "#import" do
    it "imports a video with the correct attributes" do
      expect { importer.import("test_video_slug") }.to change { Video.count }.by(1)

      video = Video.last
      expect(video.youtube_id).to eq(metadata.youtube.slug)
      expect(video.metadata.youtube.title).to eq(metadata.youtube.title)
      expect(video.metadata.youtube.description).to eq(metadata.youtube.description)
      expect(video.upload_date).to eq(Date.parse("2022-01-01"))
      expect(video.metadata.youtube.duration).to eq(180)
      expect(video.metadata.youtube.tags).to match_array(["tag1", "tag2"])
      expect(video.metadata.youtube.hd).to be(true)
      expect(video.metadata.youtube.view_count).to eq(1000)
      expect(video.metadata.youtube.favorite_count).to eq(100)
      expect(video.metadata.youtube.comment_count).to eq(50)
      expect(video.metadata.youtube.like_count).to eq(200)
      expect(video.song).to eq(songs(:nueve_de_julio))
      expect(video.channel).to eq(channels(:"030tango"))
      expect(video.dancers).to match_array([dancers(:carlitos), dancers(:noelia)])
      expect(video.couples).to eq([couples(:carlitos_noelia)])
      expect(video.metadata).to eq(metadata)
    end
  end

  context "when a video with the same youtube slug already exists" do
    let(:existing_video) { videos(:video_1_featured) }

    it "updates the existing video" do
      expect { importer.import(videos(:video_1_featured).youtube_id) }.not_to change { Video.count }

      existing_video.reload
    end
  end

  describe "#update" do
    let(:existing_video) { videos(:video_1_featured) }

    before do
      allow(video_crawler).to receive(:metadata).with(existing_video.youtube_id, use_scraper: false, use_music_recognizer: false).and_return(metadata)
      existing_video.assign_attributes(metadata: nil)
    end

    it "updates a existing video with the correct attributes" do
      expect(importer.update(existing_video)).to eq(existing_video)
      expect(existing_video.metadata).to eq(metadata)
    end
  end
end
