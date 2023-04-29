# frozen_string_literal: true

module ExternalVideoImport
  class Importer
    def initialize(song_matcher: SongMatcher.new, video_crawler: Crawler.new, channel_matcher: ChannelMatcher.new, dancer_matcher: DancerMatcher.new)
      @song_matcher = song_matcher
      @video_crawler = video_crawler
      @channel_matcher = channel_matcher
      @dancer_matcher = dancer_matcher
    end

    def import(youtube_slug)
      metadata = @video_crawler.crawl(youtube_slug)
      Video.transaction do
        video = ::Video.create!(
          youtube_slug: youtube_slug,
          title: metadata.youtube.title,
          description: metadata.youtube.description,
          upload_date: metadata.youtube.upload_date,
          duration: metadata.youtube.duration,
          tags: metadata.youtube.tags,
          hd: metadata.youtube.hd,
          view_count: metadata.youtube.view_count,
          favorite_count: metadata.youtube.favorite_count,
          comment_count: metadata.youtube.comment_count,
          like_count: metadata.youtube.like_count,
          thumbnail_url: metadata.youtube.thumbnail_url,
          recommended_video_ids: metadata.youtube.recommended_video_ids,
          channel: @channel_matcher.match(channel_metadata: metadata.youtube.channel),
          songs: @song_matcher.match(metadata_fields: metadata.searchable_music_fields, artist_fields: metadata.searchable_artist_names, title_fields: metadata.searchable_song_titles, genre_fields: metadata.genre_fields),
          dancers: @dancer_matcher.match(metadata_fields: metadata.youtube.title)
        )
        video
      end
    end
  end
end
