# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class PerformanceMatcher
      PERFORMANCE_REGEX = /(?<=\s|^|#)[1-8]\s?(of|de|\/|-|\|)\s?[1-8](\s+$|)/

      Performance = Struct.new(:position, :total)

      def parse(text:)
        return unless text.match?(PERFORMANCE_REGEX)

        performance_array = text.match(PERFORMANCE_REGEX)[0].tr("^0-9", " ").split.map(&:to_i)
        return if performance_array.empty? || performance_array.first > performance_array.second || performance_array.second == 1

        Performance.new(performance_array.first, performance_array.second)
      end
    end
  end
end
