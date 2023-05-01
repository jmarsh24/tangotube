# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Importer do
  fixtures :all

  let(:song_matcher) { instance_double("SongMatcher") }
  let(:video_crawler) { instance_double("Crawler") }
  let(:channel_matcher) { instance_double("ChannelMatcher") }
  let(:dancer_matcher) { instance_double("DancerMatcher") }
  let(:couple_matcher) { instance_double("CoupleMatcher") }
  let(:performance_matcher) { instance_double("PerformanceMatcher") }

  let(:importer) do
    described_class.new(
      video_crawler: video_crawler,
      metadata_processor: ExternalVideoImport::MetadataProcessing::MetadataProcessor.new
    )
  end
  let(:video) { videos(:video_1_featured) }
  let(:song) { songs(:nueve_de_julio) }
  let(:channel) { channels(:"030tango") }
  let(:carlitos) { dancers(:carlitos) }
  let(:noelia) { dancers(:noelia) }
  let(:couple) { couples(:carlitos_noelia) }
  let(:performance) { ExternalVideoImport::MetadataProcessing::PerformanceMatcher::Performance.new(position: 3, total: 5) }
  let(:youtube_slug) { "test_video_slug" }
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

  before do
    stub_request(:get, "https://api.spotify.com/v1/tracks/6wcryUdE3GbVVnuBFE6Zmv")
      .to_return(body: file_fixture("spotify_response.json").read)
    stub_request(:get, "https://api.spotify.com/v1/artists/649cpnHPJs3XtCIa3XUfq3")
      .to_return(body: file_fixture("spotify_response_1.json").read)
    allow(video_crawler).to receive(:metadata).with(slug: youtube_slug).and_return(metadata)
  end

  describe "#import" do
    before do
      allow(song_matcher).to receive(:match_or_create).and_return([song])
      allow(channel_matcher).to receive(:match_or_create).and_return(channel)
      allow(dancer_matcher).to receive(:match).and_return([carlitos, noelia])
      allow(couple_matcher).to receive(:match_or_create).and_return(couple)
      allow(performance_matcher).to receive(:parse).and_return(performance)
    end

    it "imports a video with the correct attributes" do
      expect { importer.import(youtube_slug) }.to change { Video.count }.by(1)

      video = Video.last
      expect(video.youtube_id).to eq(metadata.youtube.slug)
      expect(video.title).to eq(metadata.youtube.title)
      expect(video.description).to eq(metadata.youtube.description)
      expect(video.upload_date).to eq(Date.parse("2022-01-01"))
      expect(video.duration).to eq(180)
      expect(video.tags).to match_array(["tag1", "tag2"])
      expect(video.hd).to eq(true)
      expect(video.view_count).to eq(1000)
      expect(video.favorite_count).to eq(100)
      expect(video.comment_count).to eq(50)
      expect(video.like_count).to eq(200)
      expect(video.song).to eq(song)
      expect(video.channel).to eq(channel)
      expect(video.dancers).to match_array(couple.dancers)
      expect(video.couples).to match_array(couple)
      expect(video.performance_number).to eq(performance.position)
      expect(video.performance_total_number).to eq(performance.total)
      expect(video.metadata).to eq(metadata.as_json)
    end
  end

  describe "#update" do
    before do
      allow(video_crawler).to receive(:metadata).with(slug: video.youtube_id).and_return(metadata)
      video.assign_attributes(title: "Old Title", description: "Old Description")
    end

    it "updates a video with the correct attributes" do
      expect(importer.update(video)).to eq(video)

      expect(video.youtube_id).to eq(metadata.youtube.slug)
      expect(video.title).to eq(metadata.youtube.title)
      expect(video.description).to eq(metadata.youtube.description)
      expect(video.upload_date).to eq(Date.parse("2022-01-01"))
      expect(video.duration).to eq(180)
      expect(video.tags).to match_array(["tag1", "tag2"])
      expect(video.hd).to eq(true)
      expect(video.view_count).to eq(1000)
      expect(video.favorite_count).to eq(100)
      expect(video.comment_count).to eq(50)
      expect(video.like_count).to eq(200)
      expect(video.song).to eq(song)
      expect(video.channel).to eq(channel)
      expect(video.dancers).to match_array(couple.dancers)
      expect(video.couples).to match_array(couple)
      expect(video.performance_number).to eq(performance.position)
      expect(video.performance_total_number).to eq(performance.total)
      expect(video.metadata).to eq(metadata.as_json)
    end
  end
end
