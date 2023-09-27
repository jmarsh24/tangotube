# frozen_string_literal: true

require "system_helper"

RSpec.describe "homepage", type: :system do
  fixtures :all

  context "banner" do
    xit "displays the banner" do
      visit root_path
      expect(page).to have_content("The new way to watch Tango")

      screenshot "homepage_banner_present"
    end
  end

  context "videos" do
    before do
      VideoSearch.refresh
      page.driver.set_cookie("banner_closed", "true")
      visit root_path
      accept_all_button = find(".personalization-request__content a.button.button--primary", text: "Accept all")
      accept_all_button.click
    end

    xit "displays featured videos" do
      skip "Waiting for videosearch to be refactored"
      featured_videos = [videos(:video_1_featured), videos(:video_2_featured), videos(:video_3_featured), videos(:video_4_featured)]

      screenshot "homepage_videos_present"

      featured_videos.each do |video|
        expect(page).to have_content(video.song.full_title)
        video.dancers.each do |dancer|
          expect(page).to have_content(dancer.name)
        end
      end
    end
  end
end
