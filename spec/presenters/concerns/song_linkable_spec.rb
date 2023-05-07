# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongLinkable, type: :concern do
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  fixtures :all

  subject { presenter.song_link }

  let(:video) { videos(:video_1_featured) }
  let(:song) { songs(:cuando_el_amor_muere) }
  let(:presenter) { VideoPresenter.new(video) }

  context "when the video has an external song match but no song" do
    before do
      allow(presenter).to receive(:song).and_return(nil)
      allow(presenter).to receive(:youtube_song_attributes).and_return("Song Title - Artist Name - Tango")
      allow(presenter).to receive(:music).and_return(double(genre: "Tango"))
      allow(presenter).to receive(:youtube_id).and_return(video.youtube_id)
    end

    it "renders a link to the song search page with external song attributes" do
      expect(subject).to eq(link_to("Song Title - Artist Name - Tango", root_path(query: "Song Title Artist Name Tango")))
    end
  end

  context "when the video has a song" do
    it "renders a link to the song" do
      expect(subject).to eq(link_to(song.full_title, root_path(song: song.slug)))
    end
  end
end
