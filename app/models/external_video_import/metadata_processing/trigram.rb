# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class Trigram
      class << self
        def similarity(word1, word2)
          tri1 = trigram(word1)
          tri2 = trigram(word2)

          return 0.0 if [tri1, tri2].any? { |arr| arr.size == 0 }

          same_size = (tri1 & tri2).size
          all_size = (tri1 | tri2).size

          same_size.to_f / all_size
        end

        private

        def trigram(word)
          return [] if word.strip == ""

          parts = []
          padded = "  #{word} ".downcase
          padded.chars.each_cons(3) { |w| parts << w.join }
          parts
        end
      end
    end
  end
end
