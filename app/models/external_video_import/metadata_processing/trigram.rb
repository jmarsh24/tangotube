# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class Trigram
      def initialize(haystack)
        @haystack_trigrams = generate_trigrams(haystack)
      end

      def similarity(needle)
        tri1 = generate_trigrams(needle)

        return 0.0 if tri1.empty?

        common_trigrams = (tri1 & @haystack_trigrams).size
        score = common_trigrams.to_f / tri1.size

        adjusted_score = score * (1 + needle.length * 0.01)

        [adjusted_score, 1.0].min
      end

      private

      def generate_trigrams(word)
        return [] if word.strip.empty?

        padded = "  #{word.downcase}  "
        padded.chars.each_cons(3).map(&:join)
      end
    end
  end
end
