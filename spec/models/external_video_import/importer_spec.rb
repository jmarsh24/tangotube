# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalVideoImport::Importer do
  # test with special characters
  # describe "#best_match" do
  #   it "computes the similarity" do
  #     expect(ExternalVideoImport::MetadataProcessing::Trigram.best_match(list: [1, "he is genius", "test"], text: "he is very genius")).to eq 0.5625

  #     expect(ExternalVideoImport::MetadataProcessing::Trigram.best_match(list: [1, "he is genius", "test"], text: "I can fly")).to eq 0

  #     expect(ExternalVideoImport::MetadataProcessing::Trigram.best_match(list: [1, "he is genius", "test"], text: "he is genius")).to eq 1
  #   end
  # end
end
