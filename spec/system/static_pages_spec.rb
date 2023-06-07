require "rails_helper"

RSpec.feature "Static Pages", type: :feature do
  scenario "User visits the contact page" do
    visit "/contact"
    expect(page).to have_content("Contact")
    expect(page).to have_http_status(:success)
  end

  scenario "User visits the about page" do
    visit "/about"
    expect(page).to have_content("About")
    expect(page).to have_http_status(:success)
  end

  scenario "User visits the privacy policy page" do
    visit "/privacy"
    expect(page).to have_content("Privacy Policy")
    expect(page).to have_http_status(:success)
  end

  scenario "User visits the terms page" do
    visit "/terms"
    expect(page).to have_content("Terms")
    expect(page).to have_http_status(:success)
  end
end
