# frozen_string_literal: true

require "rails_helper"

RSpec.describe MetaDataDisplayable, type: :module do
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers
  fixtures :all

  let(:video) { videos(:video_1_featured) }

  let(:presenter) do
    VideoPresenter.new(video)
  end

  describe "#display_metadata" do
    it "returns a formatted string with upload date, views, and likes" do
      expect(presenter.display_metadata).to eq("October 2014 • 1K views • 3 likes")
    end
  end
end
