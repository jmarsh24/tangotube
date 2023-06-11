# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Youtube::MetadataProvider do
  let(:api_client_metadata) do
    ExternalVideoImport::Youtube::ApiClient::Metadata.new(
      slug: "video_slug",
      title: "title",
      description: "description",
      upload_date: "upload_date",
      duration: "duration",
      tags: "tags",
      hd: true,
      view_count: 100,
      favorite_count: 50,
      comment_count: 20,
      like_count: 70,
      thumbnail_url: "thumbnail_url",
      channel: "channel"
    )
  end

  let(:scraped_data) do
    ExternalVideoImport::Youtube::Scraper::ScrapedData.new(
      song: ["song"],
      recommended_video_ids: ["recommended_video_ids"]
    )
  end

  let(:metadata_provider_no_song) do
    ExternalVideoImport::Youtube::MetadataProvider::VideoMetadata.new(
      slug: "video_slug",
      title: "title",
      description: "description",
      upload_date: "upload_date",
      duration: "duration",
      tags: "tags",
      hd: true,
      view_count: 100,
      favorite_count: 50,
      comment_count: 20,
      like_count: 70,
      thumbnail_url: "thumbnail_url",
      channel: "channel",
      song: nil,
      recommended_video_ids: []
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

        metadata_provider = ExternalVideoImport::Youtube::MetadataProvider.new(api_client:, scraper:, use_scraper: true)
        video_metadata = metadata_provider.video_metadata(slug)

        expect(video_metadata.slug).to eq("video_slug")
        expect(video_metadata.title).to eq("title")
        expect(video_metadata.description).to eq("description")
        expect(video_metadata.upload_date).to eq("upload_date")
        expect(video_metadata.duration).to eq("duration")
        expect(video_metadata.tags).to eq("tags")
        expect(video_metadata.hd).to be(true)
        expect(video_metadata.view_count).to eq(100)
        expect(video_metadata.favorite_count).to eq(50)
        expect(video_metadata.comment_count).to eq(20)
        expect(video_metadata.like_count).to eq(70)
        expect(video_metadata.song).to eq(["song"])
        expect(video_metadata.thumbnail_url).to eq("thumbnail_url")
        expect(video_metadata.recommended_video_ids).to eq(["recommended_video_ids"])
        expect(video_metadata.channel).to eq("channel")
      end

      it "fetches the metadata from the API client if scraping returns nil" do
        api_client = ExternalVideoImport::Youtube::ApiClient.new
        scraper = ExternalVideoImport::Youtube::Scraper.new
        allow(api_client).to receive(:metadata).with(slug).and_return(api_client_metadata)
        allow(scraper).to receive(:data).with(slug).and_return(nil)

        metadata_provider = ExternalVideoImport::Youtube::MetadataProvider.new(api_client:, scraper:, use_scraper: true)
        video_metadata = metadata_provider.video_metadata(slug)

        expect(video_metadata.song).to be_nil
        expect(video_metadata.recommended_video_ids).to eq([])
      end
    end

    context "when use_scraper is false" do
      it "fetches the metadata from the API client and does not call the scraper" do
        api_client = ExternalVideoImport::Youtube::ApiClient.new
        scraper = ExternalVideoImport::Youtube::Scraper.new
        allow(api_client).to receive(:metadata).with(slug).and_return(api_client_metadata)

        metadata_provider = ExternalVideoImport::Youtube::MetadataProvider.new(api_client:, scraper:, use_scraper: false)
        video_metadata = metadata_provider.video_metadata(slug)

        expect(scraper).not_to receive(:data)
        expect(video_metadata.song).to be_nil
        expect(video_metadata.recommended_video_ids).to eq([])
      end
    end
  end
end
