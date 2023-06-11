# frozen_string_literal: true

module ExternalVideoImport
  module Youtube
    class MetadataProvider
      def initialize(api_client: ApiClient.new, scraper: nil)
        @api_client = api_client
        @scraper = scraper if scraper
      end

      def video_metadata(slug, use_scraper: true)
        api_client_metadata = @api_client.metadata(slug)

        scraped_data = (use_scraper && @scraper) ? @scraper.data(slug) : nil

        if use_scraper && scraped_data
          VideoMetadata.new(
            slug:,
            title: api_client_metadata.title,
            description: api_client_metadata.description,
            upload_date: api_client_metadata.upload_date,
            duration: api_client_metadata.duration,
            tags: api_client_metadata.tags,
            hd: api_client_metadata.hd,
            view_count: api_client_metadata.view_count,
            favorite_count: api_client_metadata.favorite_count,
            comment_count: api_client_metadata.comment_count,
            like_count: api_client_metadata.like_count,
            song: scraped_data.song,
            thumbnail_url: api_client_metadata.thumbnail_url,
            recommended_video_ids: scraped_data.recommended_video_ids,
            channel: api_client_metadata.channel
          )
        else
          VideoMetadata.new(
            slug:,
            title: api_client_metadata.title,
            description: api_client_metadata.description,
            upload_date: api_client_metadata.upload_date,
            duration: api_client_metadata.duration,
            tags: api_client_metadata.tags,
            hd: api_client_metadata.hd,
            view_count: api_client_metadata.view_count,
            favorite_count: api_client_metadata.favorite_count,
            comment_count: api_client_metadata.comment_count,
            like_count: api_client_metadata.like_count,
            song: nil,
            thumbnail_url: api_client_metadata.thumbnail_url,
            recommended_video_ids: [],
            channel: api_client_metadata.channel
          )
        end
      end
    end
  end
end
