# frozen_string_literal: true

require "system_helper"

RSpec.describe "homepage", type: :system do
  fixtures :all

  before do
    VideoSearch.refresh
    visit root_path
  end

  context "banner" do
    it "displays the banner" do
      expect(page).to have_content("The new way to watch Tango")

      screenshot "homepage_banner_present"
    end
  end

  context "videos" do
    before do
      find(".banner__card .icon.icon--close").click
      accept_all_button = find(".personalization-request__content a.button.button--primary", text: "Accept all")
      accept_all_button.click
      page.evaluate_script("document.cookie = 'banner_closed=true; path=/;'")
    end

    it "displays featured videos" do
      featured_videos = [videos(:video_1_featured), videos(:video_2_featured), videos(:video_3_featured), videos(:video_4_featured)]

      screenshot "homepage_featured_videos_present"

      expect(page).to have_content("Featured videos")
      featured_videos.each do |video|
        expect(page).to have_content(video.song.full_title)
        video.dancers.each do |dancer|
          expect(page).to have_content(dancer.name)
        end
      end
    end
  end
end
