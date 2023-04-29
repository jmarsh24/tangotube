require "rails_helper"

RSpec.describe ExternalVideoImport::Importer do
  fixtures :songs, :channels, :dancers, :couples, :performances

  let(:song_matcher) { instance_double("SongMatcher") }
  let(:video_crawler) { instance_double("Crawler") }
  let(:channel_matcher) { instance_double("ChannelMatcher") }
  let(:dancer_matcher) { instance_double("DancerMatcher") }
  let(:couple_matcher) { instance_double("CoupleMatcher") }
  let(:performance_matcher) { instance_double("PerformanceMatcher") }

  let(:importer) do
    ExternalVideoImport::Importer.new(
      song_matcher: song_matcher,
      video_crawler: video_crawler,
      channel_matcher: channel_matcher,
      dancer_matcher: dancer_matcher,
      couple_matcher: couple_matcher,
      performance_matcher: performance_matcher
    )
  end

  let(:song) { songs(:nueve_de_julio) }
  let(:channel) { channels(:"030tango") }
  let(:carlitos) { dancers(:carlitos) }
  let(:noelia) { dancers(:noelia) }
  let(:couple) { couples(:carlitos_noelia) }
  let(:performance) { ExternalVideoImport::MetadataProcessing::PerformanceMatcher::Performance.new(position: 3, total: 5) }
  let(:youtube_slug) { "test_video_slug" }
  let(:metadata_yaml) { YAML.load_file(Rails.root.join("spec/fixtures/metadata.yml")) }
  let(:metadata) do
    ExternalVideoImport::Crawler::Metadata.new(
      youtube: ExternalVideoImport::Youtube::VideoMetadata.new(
        slug: "test_video_slug",
        title: "Test Video Title",
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
          id: "test_channel_id",
          title: "Test Channel"
        }
      ),
      music: ExternalVideoImport::MusicRecognition::MusicRecognizer::Metadata.new(
        acr_song_title: "Song 1",
        acr_artist_names: ["Artist 1", "Artist 2"],
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
      allow(song_matcher).to receive(:match).and_return([song])
      allow(channel_matcher).to receive(:match).and_return(channel)
      allow(dancer_matcher).to receive(:match).and_return([carlitos, noelia])
      allow(couple_matcher).to receive(:match_or_create).and_return(couple)
      allow(performance_matcher).to receive(:parse).and_return(performance)
    end

    it "imports a video with the correct attributes" do
      dancers = [carlitos, noelia]
      expect { importer.import(youtube_slug) }.to change(Video, :count).by(1)

      video = Video.last
      expect(video.youtube_id).to eq(metadata.youtube.slug)
      expect(video.title).to eq(metadata.youtube.title)
      # ... test all other video attributes
      # expect(video.song).to eq(song)
      expect(video.channel).to eq(channel)
      expect(video.dancers).to match_array(dancers)
      expect(video.couples).to match_array([couple])
      # expect(video.performance_number).to eq(performance.position)
      # expect(video.performance_total_number).to eq(performance.total)
    end
  end
end
