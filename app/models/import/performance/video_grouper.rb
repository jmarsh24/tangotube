# frozen_string_literal: true

module Import
  module Performance
    class VideoGrouper
      def initialize(video:)
        @video = video
        @parser = Performance::Parser.new
      end

      def group_to_performance
        return if @video.leaders.empty? || @video.followers.empty?

        videos = Video.within_week_of(@video.upload_date)

        leader = @video.leaders&.first&.slug
        follower = @video.followers&.first&.slug
        channel = @video.channel.youtube_slug

        filtering_params = {
          channel:,
          leader:,
          follower:,
          hidden: false
        }

        performance_videos = Video::Filter.new(videos, filtering_params:).videos

        performance = if performance_videos.any? && performance_videos.first.performance
          performance_videos.first.performance
        else
          ::Performance.create!
        end

        performance_videos.each do |video|
          parsed_data = @parser.parse(text: video.title)
          if video.performance
            video.performance_video.update!(position: parsed_data.position) if parsed_data
          else
            PerformanceVideo.create!(performance:, video:, position: parsed_data&.position)
          end
        end

        unless @video.performance
          parsed_data = @parser.parse(text: @video.title)
          PerformanceVideo.create!(performance:, video: @video, position: parsed_data.position) if parsed_data
        end

        performance
      end
    end
  end
end
