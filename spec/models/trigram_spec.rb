require "rails_helper"

RSpec.describe Trigram do
  describe "#similarity" do
    it "computes the similarity" do
      expect(Trigram.similarity("he is genius", "he is very genius")).to eq 0.5625

      expect(Trigram.similarity("he is genius", "I can fly")).to eq 0

      expect(Trigram.similarity("he is genius", "he is genius")).to eq 1
    end
  end

  describe "#word_similarity" do
    it "computes the word similarity" do
      expect(Trigram.word_similarity("he is genius", "he is very genius")).to eq 1.0

      expect(Trigram.word_similarity("he is genius", "I can fly")).to eq 0

      expect(Trigram.word_similarity("he is genius", "he is genius")).to eq 1
    end
  end

  it "can change the order of arguments" do
    a, b = "he is genius", "he is very genius"
    expect(Trigram.similarity(a, b)).to eq Trigram.similarity(b, a)
  end
end
