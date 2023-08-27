# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class MetadataProcessor
      def process(metadata)
        dancers = DancerMatcher.new.match(video_title: metadata.youtube.title)
        couple = CoupleMatcher.new.match_or_create(dancers:)
        song = match_song(metadata)

        video_data = {
          youtube_id: metadata.youtube.slug,
          upload_date: metadata.youtube.upload_date.to_datetime,
          upload_date_year: metadata.youtube.upload_date.year,
          title: metadata.youtube.title,
          description: metadata.youtube.description,
          channel: ChannelMatcher.new.match_or_create(channel_metadata: metadata.youtube.channel),
          song:,
          event: EventMatcher.new.match(video_title: metadata.youtube.title, video_description: metadata.youtube.description),
          couples: [couple].compact,
          acr_response_code: metadata.music&.code,
          duration: metadata.youtube.duration,
          hd: metadata.youtube.hd,
          youtube_view_count: metadata.youtube.view_count,
          youtube_like_count: metadata.youtube.like_count,
          youtube_tags: metadata.youtube.tags,
          hidden: metadata.youtube.blocked
        }
        video_data[:dancer_videos] = dancers.map do |dancer|
          role = (dancer.gender == "male") ? "leader" : "follower"
          DancerVideo.new(dancer:, role:)
        end
        video_data
      end

      private

      def match_song(metadata)
        song = SongMatcher.new.match(
          video_title: metadata.youtube.title,
          video_description: metadata.youtube.description,
          song_titles: metadata.song_titles,
          song_artists: metadata.artist_names,
          song_albums: metadata.album_names
        )

        if song && metadata.music
          song.spotify_track_id ||= metadata.music.spotify_track_id
          song.save! if song.changed?
        end

        song
      end
    end
  end
end
