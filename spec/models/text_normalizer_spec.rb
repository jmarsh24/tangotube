# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextNormalizer do
  it "normalizes text" do
    expect(TextNormalizer.normalize("Sábado inglés")).to eq("sabado ingles")
  end

  it "normalizes text with apostrophes" do
    expect(TextNormalizer.normalize("Тополиный пух")).to eq("")
  end

  it "normalizes text with hyphens" do
    text = 'Barbara Ferreyra y Agustin Agnez-1/2-"Silence,On Danse"Tango Festival-Dime Mi Amor-Orq.Darienzo'
    expect(TextNormalizer.normalize(text)).to eq("barbara ferreyra agustin agnez 1 2 silence danse tango festival dime mi amor orq darienzo")
  end
end
