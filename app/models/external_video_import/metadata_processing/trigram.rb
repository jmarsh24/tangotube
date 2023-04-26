# frozen_string_literal: true

module ExternalVideoImport
  module MetadataProcessing
    class Trigram
      class << self
        def best_match(list:, text:, threshold: 0.3, &block)
          list.map do |item|
            search_string = block.call(item)
            similarity_ratio = inclusion_similarity(search_string, text)
            [item, similarity_ratio]
          end.select { |_, similarity| similarity >= threshold }.max_by { |_, similarity| similarity }
        end

        private

        def inclusion_similarity(text1, text2)
          text1_trigrams = trigramify(text1)
          text2_trigrams = trigramify(text2)

          same_size = (text1_trigrams & text2_trigrams).size

          same_size.to_f / text1_trigrams.size
        end

        def trigramify(text)
          text.parameterize(" ").chars.each_cons(3).map(&:join)
        end
      end
    end
  end
end
