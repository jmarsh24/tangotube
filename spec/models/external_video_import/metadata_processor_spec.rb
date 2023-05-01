# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::MetadataProcessing::MetadataProcessor do
  fixtures :couples, :dancers

  let(:song_matcher) { instance_double("SongMatcher") }
  let(:channel_matcher) { instance_double("ChannelMatcher") }
  let(:dancer_matcher) { instance_double("DancerMatcher") }
  let(:couple_matcher) { instance_double("CoupleMatcher") }
  let(:performance_matcher) { instance_double("PerformanceMatcher") }

  subject(:metadata_processor) do
    described_class.new(
      song_matcher: song_matcher,
      channel_matcher: channel_matcher,
      dancer_matcher: dancer_matcher,
      couple_matcher: couple_matcher,
      performance_matcher: performance_matcher
    )
  end

  let(:metadata) { double("metadata") }

  describe "#process" do
    let(:youtube_metadata) { double("youtube_metadata") }
    let(:channel_metadata) { double("channel_metadata") }
    let(:performance_metadata) { double("performance_metadata") }
    let(:song_metadata) { double("song_metadata") }
    let(:couple) { couples(:carlitos_noelia) }

    before do
      allow(metadata).to receive(:youtube).and_return(youtube_metadata)
      allow(metadata).to receive(:searchable_music_fields).and_return([])
      allow(metadata).to receive(:searchable_artist_names).and_return([])
      allow(metadata).to receive(:searchable_song_titles).and_return([])
      allow(metadata).to receive(:genre_fields).and_return([])
      allow(performance_metadata).to receive(:position).and_return(3)
      allow(performance_metadata).to receive(:total).and_return(5)

      allow(youtube_metadata).to receive(:title).and_return("Test Video Title")
      allow(youtube_metadata).to receive(:description).and_return("Test video description")
      allow(youtube_metadata).to receive(:slug).and_return("test_video_slug")
      allow(youtube_metadata).to receive(:upload_date).and_return("2022-01-01")
      allow(youtube_metadata).to receive(:duration).and_return(180)
      allow(youtube_metadata).to receive(:tags).and_return(["tag1", "tag2"])
      allow(youtube_metadata).to receive(:hd).and_return(true)
      allow(youtube_metadata).to receive(:view_count).and_return(1000)
      allow(youtube_metadata).to receive(:favorite_count).and_return(100)
      allow(youtube_metadata).to receive(:comment_count).and_return(50)
      allow(youtube_metadata).to receive(:like_count).and_return(200)
      allow(youtube_metadata).to receive(:channel).and_return(channel_metadata)

      allow(channel_matcher).to receive(:match_or_create).with(channel_metadata: channel_metadata).and_return("matched_channel")
      allow(dancer_matcher).to receive(:match).with(metadata_fields: youtube_metadata.title).and_return(couple.dancers)
      allow(couple_matcher).to receive(:match_or_create).with(dancers: couple.dancers).and_return(couple)
      allow(performance_matcher).to receive(:parse).with(text: "#{youtube_metadata.title} #{youtube_metadata.description}").and_return(performance_metadata)
      allow(song_matcher).to receive(:match_or_create).with(
        metadata_fields: [],
        artist_fields: [],
        title_fields: [],
        genre_fields: []
      ).and_return([song_metadata])
    end

    it "processes the metadata and returns the video attributes" do
      expect(channel_matcher).to receive(:match_or_create).with(channel_metadata: channel_metadata).and_return("matched_channel")
      expect(dancer_matcher).to receive(:match).with(metadata_fields: youtube_metadata.title).and_return(dancers)
      expect(couple_matcher).to receive(:match_or_create).with(dancers: dancers).and_return(couple)
      expect(performance_matcher).to receive(:parse).with(text: "#{youtube_metadata.title} #{youtube_metadata.description}").and_return(performance_metadata)
      expect(song_matcher).to receive(:match_or_create).with(
        metadata_fields: [],
        artist_fields: [],
        title_fields: [],
        genre_fields: []
      ).and_return([song_metadata])

      attributes = metadata_processor.process(metadata)

      expect(attributes).to eq(
        youtube_id: "test_video_slug",
        title: "Test Video Title",
        description: "Test video description",
        upload_date: "2022-01-01",
        duration: 180,
        tags: ["tag1", "tag2"],
        hd: true,
        view_count: 1000,
        favorite_count: 100,
        comment_count: 50,
        like_count: 200,
        channel: "matched_channel",
        song: song_metadata,
        dancers: dancers,
        couples: couple,
        performance_number: performance_metadata&.position,
        performance_total_number: performance_metadata&.total
      )
    end
  end
end
