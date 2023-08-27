# frozen_string_literal: true

require "fuzzystringmatch"

module ExternalVideoImport
  module MetadataProcessing
    class FuzzyText
      def initialize
        @groups_cache = {}
      end

      def jaro_winkler_score(needle:, haystack:)
        attribute_groups = generate_attribute_groups(haystack, count_words(needle) + 2)
        scores = attribute_groups.map { |group| calculate_similarity_score(needle, group) }

        scores.compact.max || 0
      end

      def trigram_score(needle:, haystack:)
        attribute_groups = generate_attribute_groups(haystack, count_words(needle) + 2)
        scores = attribute_groups.map { |group| Trigram.similarity(needle:, haystack: group) }
        scores.compact.max || 0
      end

      private

      def generate_attribute_groups(string, n)
        return @groups_cache[string][n] if @groups_cache.dig(string, n)

        words = string.split(" ")
        groups = (1..n).flat_map { |i| generate_groups_of_n(words, i) }

        @groups_cache[string] ||= {}
        @groups_cache[string][n] = groups

        groups
      end

      def generate_groups_of_n(words, n)
        words.each_cons(n).map { |group| group.join(" ") }
      end

      def calculate_similarity_score(query, target)
        FuzzyStringMatch::JaroWinkler.create(:native).getDistance(query, target)
      end

      def count_words(str)
        str.split.size
      end
    end
  end
end
