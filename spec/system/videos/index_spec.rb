require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "header" do
    it "has logo" do
      visit videos_url

      expect(page).to have_content("TangoTube")
    end

    it "has login links" do
      visit videos_url

      expect(page).to have_content("Sign up")
      expect(page).to have_content("Login")
      expect(page).to have_link "Sign up", href: new_user_registration_path
      expect(page).to have_link "Login", href: new_user_session_path
    end

    it "has has add resource links" do
      visit videos_url

      expect(page).to have_link "Add Channel", href: channels_path
      expect(page).to have_link "Add Playlist", href: playlists_path
      expect(page).to have_link "Add Video", href: new_video_path
    end

    # describe "has search bar" do
    #   it "has input field" do
    #     visit videos_url

    #     expect(page).to have_content
    #   end

    #   it "has submit button" do
    #     visit videos_url

    #     expect(page).to have_content("Add Video")
    #     assert_selector "button", class: "searchButton"
    #   end
    # end

    # describe "has autocomplete" do
    #   it "opens autocomplete window" do
    #     VideosSearch.refresh
    #     visit videos_url
    #     fill_in "query", with: "a"
    #     click_on(class: "searchButton")
    #     assert_selector "span"
    #     # assert_selector "span", class: "aa-dropdown-menu"
    #   end
    # end
  end

  describe "filters" do
    it "can select" do
      visit videos_url
      assert_selector "a", text: "TangoTube"
    end
  end
end
