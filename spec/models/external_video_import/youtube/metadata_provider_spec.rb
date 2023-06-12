# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Youtube::MetadataProvider do
  let(:thumbnail_url) { ExternalVideoImport::Youtube::ThumbnailUrl.new(standard: "thumbnail_url") }

  let(:api_client_metadata) do
    ExternalVideoImport::Youtube::ApiMetadata.new(
      slug: "video_slug",
      title: "title",
      description: "description",
      upload_date: Date.new(2023, 6, 11),
      duration: 100,
      tags: ["tags"],
      hd: true,
      view_count: 100,
      favorite_count: 50,
      comment_count: 20,
      like_count: 70,
      thumbnail_url:,
      channel_id: "channel_id",
      channel_title: "channel title"
    )
  end

  let(:song_metadata) do
    ExternalVideoImport::Youtube::SongMetadata.new(
      titles: ["titles"],
      song_url: "song_url",
      artist: "artist",
      artist_url: "artist_url",
      writers: ["writers"],
      album: "album"
    )
  end

  let(:scraped_data) do
    ExternalVideoImport::Youtube::ScrapedData.new(
      song: song_metadata,
      recommended_video_ids: ["recommended_video_ids"]
    )
  end

  describe "#video_metadata" do
    let(:slug) { "video_slug" }

    context "when use_scraper is true" do
      it "returns the scraped metadata if available" do
        api_client = ExternalVideoImport::Youtube::ApiClient.new
        scraper = ExternalVideoImport::Youtube::Scraper.new
        allow(api_client).to receive(:metadata).with(slug).and_return(api_client_metadata)
        allow(scraper).to receive(:data).with(slug).and_return(scraped_data)

        metadata_provider = ExternalVideoImport::Youtube::MetadataProvider.new(api_client:, scraper:)
        video_metadata = metadata_provider.video_metadata(slug, use_scraper: true)

        expect(video_metadata.slug).to eq("video_slug")
        expect(video_metadata.title).to eq("title")
        expect(video_metadata.description).to eq("description")
        expect(video_metadata.upload_date).to eq(Date.new(2023, 6, 11))
        expect(video_metadata.duration).to eq(100)
        expect(video_metadata.tags).to eq(["tags"])
        expect(video_metadata.hd).to be(true)
        expect(video_metadata.view_count).to eq(100)
        expect(video_metadata.favorite_count).to eq(50)
        expect(video_metadata.comment_count).to eq(20)
        expect(video_metadata.like_count).to eq(70)
        expect(video_metadata.song.titles).to eq(["titles"])
        expect(video_metadata.song.song_url).to eq("song_url")
        expect(video_metadata.song.artist).to eq("artist")
        expect(video_metadata.song.artist_url).to eq("artist_url")
        expect(video_metadata.song.writers).to eq(["writers"])
        expect(video_metadata.song.album).to eq("album")
        expect(video_metadata.thumbnail_url.standard).to eq("thumbnail_url")
        expect(video_metadata.recommended_video_ids).to eq(["recommended_video_ids"])
        expect(video_metadata.channel_id).to eq("channel_id")
        expect(video_metadata.channel_title).to eq("channel title")
      end
    end

    context "when use_scraper is false" do
      it "fetches the metadata from the API client and does not call the scraper" do
        api_client = ExternalVideoImport::Youtube::ApiClient.new
        scraper = ExternalVideoImport::Youtube::Scraper.new
        allow(api_client).to receive(:metadata).with(slug).and_return(api_client_metadata)

        metadata_provider = ExternalVideoImport::Youtube::MetadataProvider.new(api_client:, scraper:)
        video_metadata = metadata_provider.video_metadata(slug, use_scraper: false)

        expect(scraper).not_to receive(:data)
        expect(video_metadata.song.titles).to eq([])
        expect(video_metadata.song.song_url).to be_nil
        expect(video_metadata.song.artist).to be_nil
        expect(video_metadata.song.artist_url).to be_nil
        expect(video_metadata.song.writers).to eq([])
        expect(video_metadata.song.album).to be_nil
        expect(video_metadata.recommended_video_ids).to eq([])
      end
    end
  end
end
