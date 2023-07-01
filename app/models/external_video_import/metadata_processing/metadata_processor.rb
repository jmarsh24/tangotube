# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class MetadataProcessor
      def initialize(song_matcher: SongMatcher.new, channel_matcher: ChannelMatcher.new, dancer_matcher: DancerMatcher.new, couple_matcher: CoupleMatcher.new)
        @song_matcher = song_matcher
        @channel_matcher = channel_matcher
        @dancer_matcher = dancer_matcher
        @couple_matcher = couple_matcher
      end

      def process(metadata)
        dancers = @dancer_matcher.match(metadata_fields: metadata.youtube.title)
        couples = @couple_matcher.match_or_create(dancers:)

        song = match_song(metadata)

        video_data = {
          youtube_id: metadata.youtube.slug,
          upload_date: metadata.youtube.upload_date.to_datetime,
          upload_date_year: metadata.youtube.upload_date.year,
          title: metadata.youtube.title,
          description: metadata.youtube.description,
          channel: @channel_matcher.match_or_create(channel_metadata: metadata.youtube.channel),
          song:,
          couples:,
          acr_response_code: metadata.music.code,
          duration: metadata.youtube.duration,
          hd: metadata.youtube.hd,
          youtube_view_count: metadata.youtube.view_count,
          youtube_like_count: metadata.youtube.like_count,
          youtube_tags: metadata.youtube.tags
        }

        assign_dancers_with_roles(video_data, dancers)

        video_data
      end

      private

      def match_song(metadata)
        @song_matcher.match(
          video_title: metadata.youtube.title,
          video_description: metadata.youtube.description,
          song_titles: metadata.song_titles,
          song_artists: metadata.artist_names,
          song_albums: metadata.album_names
        )
      end

      def assign_dancers_with_roles(video_data, dancers)
        video_data[:dancer_videos] = dancers.map do |dancer|
          role = determine_dancer_role(dancer)
          DancerVideo.new(dancer:, role:)
        end
      end

      def determine_dancer_role(dancer)
        (dancer.gender == "male") ? "leader" : "follower"
      end
    end
  end
end
