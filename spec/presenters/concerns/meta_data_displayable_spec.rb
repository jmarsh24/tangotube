# frozen_string_literal: true

require "rails_helper"

RSpec.describe MetaDataDisplayable, type: :module do
  include ActionView::Helpers::NumberHelper
  include Rails.application.routes.url_helpers

  let(:metadata) do
    ExternalVideoImport::Metadata.new(
      {
        youtube: {
          like_count: 1234,
          view_count: 56789,
          upload_date: Time.zone.now
        }
      }
    )
  end

  let(:video) do
    instance_double("Video", metadata:)
  end

  let(:presenter) do
    VideoPresenter.new(video)
  end

  describe "#display_metadata" do
    it "returns a formatted string with upload date, views, and likes" do
      expect(presenter.display_metadata).to eq("May 2023 • 57K views • 1.2K likes")
    end
  end
end
