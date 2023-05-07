# frozen_string_literal: true

require "rails_helper"

RSpec.describe PerformanceNumberDisplayable, type: :concern do
  fixtures :all

  let(:performance) { double(videos_count: 5) }
  let(:performance_video) { double(position: 3) }
  let(:video) { videos(:video_1_featured) }
  let(:presenter) { VideoPresenter.new(video) }

  subject { presenter.performance_number }

  context "when there is a performance" do
    before do
      allow(presenter).to receive(:performance).and_return(performance)
      allow(presenter).to receive(:performance_video).and_return(performance_video)
    end

    it "returns the position and total number of videos for the performance" do
      expect(subject).to eq("3 / 5")
    end
  end

  context "when there is no performance" do
    before do
      allow(presenter).to receive(:performance).and_return(nil)
    end

    it "returns nil" do
      expect(subject).to be_nil
    end
  end
end
