# frozen_string_literal: true

module Import
  module MetadataProcessing
    class CategoryMatcher
      CATEGORIES = {
        "interview" => ["entrevista", "interview", "tengo una pregunta para vos"],
        "class" => ["class", "clase", "resume", "musicality", "demo", "sacadas", "giros", "colgadas", "technique", "variacion"],
        "workshop" => ["workshop"]
      }.freeze

      def initialize(video_title:, dancer_count: 0)
        @video_title = video_title.downcase
        @dancer_count = dancer_count
      end

      def category
        CATEGORIES.each do |category, keywords|
          return category if keywords.any? { |keyword| @video_title.include?(keyword) }
        end

        return "performance" if @dancer_count >= 2
        nil
      end
    end
  end
end
