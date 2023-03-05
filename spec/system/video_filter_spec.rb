# frozen_string_literal: true

require "system_helper"

RSpec.describe "video filter", type: :system do
  it "closes banner and stores state" do
    visit root_path
    expect(page).to have_css ".banner__card"
    click_on "close_banner"
    expect(page).not_to have_css ".banner__card"
    visit root_path
    expect(page).not_to have_css ".banner__card"
  end

  # it "filters videos" do
  #   page.driver.set_cookie "banner_closed", "true"
  #   page.driver.set_cookie "consent", "essential"
  #   visit root_path
  #   expect(page).to have_select placeholder: "Any Leader..."
  #   fill_in_tom_select_field "#leader-filter", "Carlitos Espinoza"
  #   expect(page).to have_css "h3.heading-3"
  #   fill_in_tom_select_field "#follower-filter", "Noelia Hurtado"
  #   expect(page).to have_css "h3.heading-3"
  # end
end
