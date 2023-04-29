module ExternalVideoImport
  module MetadataProcessing
    class Trigram
      class << self
        def best_matches(list:, text:, threshold: 0.6, &block)
          matches = list.map do |item|
            query = block.call(item)
            similarity_ratio = inclusion_similarity(query, text)
            [item, similarity_ratio]
          end

          matches.select! { |_, similarity| similarity >= threshold }
          matches.sort_by! { |_, similarity| -similarity }

          matches
        end

        private

        def inclusion_similarity(item_text, query_text)
          item_text_trigrams = trigramify(item_text)
          query_text_trigrams = trigramify(query_text)
          shared_trigrams_size = (item_text_trigrams & query_text_trigrams).size
          shared_trigrams_size.to_f / item_text_trigrams.size
        end

        def trigramify(text)
          text.parameterize(separator: " ").chars.each_cons(3).map(&:join)
        end
      end
    end
  end
end
