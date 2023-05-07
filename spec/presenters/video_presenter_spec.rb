# frozen_string_literal: true

require "rails_helper"

RSpec.describe VideoPresenter do
  fixtures :videos

  let(:video) { videos(:video_1_featured) }
  let(:presenter) { described_class.new(video) }

  describe "included modules" do
    it "includes TitleLinkable" do
      expect(described_class).to include(TitleLinkable)
    end

    it "includes SongLinkable" do
      expect(described_class).to include(SongLinkable)
    end

    it "includes MetaDataDisplayable" do
      expect(described_class).to include(MetaDataDisplayable)
    end

    it "includes HdDataDisplayable" do
      expect(described_class).to include(HdDataDisplayable)
    end

    it "includes PerformanceNumberDisplayable" do
      expect(described_class).to include(PerformanceNumberDisplayable)
    end
  end

  describe "#format_date" do
    it "returns a formatted date string" do
      date = Time.zone.today
      expect(presenter.send(:format_date, date)).to eq(date.strftime("%B %Y"))
    end

    it "returns nil when given a nil date" do
      expect(presenter.send(:format_date, nil)).to be_nil
    end
  end
end
