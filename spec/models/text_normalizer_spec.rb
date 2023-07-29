# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextNormalizer do
  it "normalizes text" do
    expect(TextNormalizer.normalize("Sábado inglés")).to eq("sabado ingles")
  end
end
