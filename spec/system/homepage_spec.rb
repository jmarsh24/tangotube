# frozen_string_literal: true

require "system_helper"

RSpec.describe "homepage", type: :system do
  fixtures :all

  it "renders feedback" do
    VideoScore.refresh
    page.driver.set_cookie("banner_closed", "true")
    visit root_path

    expect(page).to have_content("tango")

    screenshot "homepage_videos_present"
  end
end
