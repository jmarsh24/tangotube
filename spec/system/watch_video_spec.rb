# frozen_string_literal: true

require "system_helper"

RSpec.describe "watch_video", type: :system do
  fixtures :all

  it "displays the video and related information" do
    video = videos(:video_1_featured)

    visit watch_path(v: video.youtube_id)

    expect(page).to have_content("Noelia Hurtado & Carlitos Espinoza")
    expect(page).to have_content(video.song.full_title)
  end
end
