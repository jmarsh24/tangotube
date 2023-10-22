# frozen_string_literal: true

require "system_helper"

RSpec.describe "homepage", type: :system do
  fixtures :all

  it "displays the banner" do
    visit root_path
    expect(page).to have_content("The new way to watch Tango")

    screenshot "homepage_banner_present"
  end

  it "renders feedback" do
    VideoScore.refresh
    page.driver.set_cookie("banner_closed", "true")
    visit root_path

    expect(page).to have_content("tango")

    screenshot "homepage_videos_present"
  end
end
