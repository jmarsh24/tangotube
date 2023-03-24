class Trigram
  class << self
    def similarity(text1, text2)
      text1_trigrams = trigramify(text1)
      text2_trigrams = trigramify(text2)

      same_size = (text1_trigrams & text2_trigrams).size
      all_size = (text1_trigrams | text2_trigrams).size

      same_size.to_f / all_size
    end

    def word_similarity(text1, text2)
      text1_words = text1.split
      text2_words = text2.split

      same_size = (text1_words & text2_words).size

      same_size.to_f / text1_words.size
    end

    private

    def trigramify(text)
      trigrams = []
      text.chars.each_cons(3) { |v| trigrams << v.join }
      trigrams
    end
  end
end
