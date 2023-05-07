# frozen_string_literal: true

require "rails_helper"

RSpec.describe TitleLinkable, type: :concern do
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  fixtures :all

  subject { presenter.title_link }

  let(:video) { videos(:video_1_featured) }
  let(:presenter) { VideoPresenter.new(video) }

  context "when there are dancers" do
    let(:dancers) { [double("dancer", full_name: "Jane Doe"), double("dancer", full_name: "John Smith")] }

    before do
      allow(presenter).to receive(:dancers).and_return(dancers)
      allow(presenter).to receive(:youtube_id).and_return(video.youtube_id)
    end

    it "renders a link to the video with dancer names" do
      expect(subject).to eq(link_to("Jane Doe & John Smith", watch_path(v: video.youtube_id)))
    end
  end

  context "when there are no dancers" do
    before do
      allow(presenter).to receive(:dancers).and_return(nil)
      allow(presenter).to receive(:metadata).and_return(double(youtube: double(title: "Video Title")))
      allow(presenter).to receive(:youtube_id).and_return(video.youtube_id)
    end

    it "renders a link to the video with video title" do
      expect(subject).to eq(link_to("Video Title", watch_path(v: video.youtube_id)))
    end
  end
end
