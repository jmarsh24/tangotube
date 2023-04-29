module ExternalVideoImport
  class Importer
    def initialize(song_matcher: SongMatcher.new, video_crawler: Crawler.new, channel_matcher: ChannelMatcher.new, dancer_matcher: DancerMatcher.new, couple_matcher: CoupleMatcher.new, performance_matcher: PerformanceMatcher.new)
      @song_matcher = song_matcher
      @video_crawler = video_crawler
      @channel_matcher = channel_matcher
      @dancer_matcher = dancer_matcher
      @couple_matcher = couple_matcher
      @performance_matcher = performance_matcher
    end

    def import(youtube_slug)
      metadata = @video_crawler.metadata(slug: youtube_slug)
      video_attributes = build_video_attributes(metadata)

      Video.transaction do
        video = ::Video.create!(video_attributes)
        video
      end
    end

    private

    def build_video_attributes(metadata)
      dancers = @dancer_matcher.match(metadata_fields: metadata.youtube.title)
      couple = @couple_matcher.match_or_create(dancers)
      performance = @performance_matcher.parse(text: [metadata.youtube.title, metadata.youtube.description])

      {
        youtube_id: metadata.youtube.slug,
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
        # thumbnail: metadata.youtube.thumbnail_url.maxres,
        # recommended_video_ids: metadata.youtube.recommended_video_ids,
        channel: @channel_matcher.match(channel_metadata: metadata.youtube.channel),
        song: @song_matcher.match(metadata_fields: metadata.searchable_music_fields, artist_fields: metadata.searchable_artist_names, title_fields: metadata.searchable_song_titles, genre_fields: metadata.genre_fields).first,
        dancers: dancers,
        couples: [couple],
        performance_number: performance&.position,
        performance_total_number: performance&.total
      }
    end
  end
end
