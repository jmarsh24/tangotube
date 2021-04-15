require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "header" do
    it "has logo" do
      visit videos_path

      expect(page).to have_content("TangoTube")
    end

    it "has login links" do
      visit videos_path

      expect(page).to have_content("Sign up")
      expect(page).to have_content("Login")
      expect(page).to have_link "Sign up", href: new_user_registration_path
      expect(page).to have_link "Login", href: new_user_session_path
    end

    it "has logged in links" do
      sign_in create(:user)
      visit videos_path

      expect(page).to have_link "Edit profile", href: edit_user_registration_path
      expect(page).to have_link "Logout", href: destroy_user_session_path
    end

    it "presents 'Signed In' alert after succesful sign in and signs out" do
      create(:user, email: "j.doe@example.com", password: "foobar1")
      visit new_user_session_url

      expect(page).to have_content("Log in to TangoTube")
      expect(page).to have_content("Remember me")

      expect(page).to have_link "Create an account", href: new_user_registration_path
      expect(page).to have_link "Forgot your password?", href: new_user_password_path

      fill_in :user_email, with: "j.doe@example.com"
      fill_in :user_password, with: "foobar1"
      click_on "Log in"

      expect(page).to have_content("Signed in successfully.")
      click_on "Logout"
      expect(page).to have_content("Signed out successfully.")
    end

    it "edit user page" do
      create(:user, email: "j.doe@example.com", password: "foobar1")
      visit new_user_session_url

      fill_in :user_email, with: "j.doe@example.com"
      fill_in :user_password, with: "foobar1"

      click_on "Log in"

      click_on "Edit profile"

      expect(page).to have_content("Edit User")
      expect(page).to have_content("Email")
      expect(page).to have_content("Password confirmation")
      expect(page).to have_content("Current password")

      expect(page).to have_content("Cancel my account")
    end

    it "successfully loads forgot your password" do
      visit new_user_session_url

      expect(page).to have_content("Forgot your password?")

      click_on "Forgot your password?"

      expect(page).to have_content("Email")
      expect(page).to have_content("Forgot your password?")

      expect(page).to have_link "Log in", href: new_user_session_path
      expect(page).to have_link "Create an account", href: new_user_registration_path
    end

    it "has has add resource links" do
      visit videos_path

      expect(page).to have_link "Add Channel", href: channels_path
      expect(page).to have_link "Add Playlist", href: playlists_path
      expect(page).to have_link "Add Video", href: new_video_path
    end

    describe "search bar" do
      it "has input field" do
        visit videos_path

        expect(page).to have_css("input#query")
      end

      it "has submit button" do
        visit videos_path

        expect(page).to have_css("button.searchButton")
      end

      # it "has autocomplete" do
      #   create(:leader, name: "autocomplete match")
      #   visit videos_path
      #   find("input#query").fill_in with: "autocomplete"
      #   expect(page).to have_content("autocomplete match")
      # end
    end
  end

  describe "filters" do
    it "can toggle filters" do
      visit videos_path
      expect(page).to have_css("div.filter-container")
      click_on("Filters")
      expect(page).not_to have_css("div.filter-container isHidden")
    end

    it "displays total results" do
      create(:video, :display)
      create(:video, :display)
      create(:video, :display)
      visit videos_path

      expect(page).to have_content("Displaying 3 Results")
    end

    it "displays all/hd buttons" do
      visit videos_path
      expect(page).to have_content("HD")
      expect(page).to have_content("All")
    end

    it "displays sorting params" do
      visit videos_path

      expect(page).to have_content("Song Title")
      expect(page).to have_content("Orchestra")
      expect(page).to have_content("Channel")
      expect(page).to have_content("View Count")
      expect(page).to have_content("Upload Date")
    end

    it "displays filters genre, leader, follower, orchestra, year" do
      visit videos_path

      expect(page).to have_select("genre-filter")
      expect(page).to have_select("leader-filter")
      expect(page).to have_select("follower-filter")
      expect(page).to have_select("orchestra-filter")
      expect(page).to have_select("year-filter")
    end
  end

  describe "footer" do
  end

  describe "navigates to watch page" do
  end

  describe "videos" do
  end

  describe "sorts" do
  end

  describe "pagination" do
    it "shows last page if next_page empty" do
      stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 5)
      create(:video, :display)
      create(:video, :display)
      create(:video, :display)
      visit videos_path

      expect(page).to have_content("Displaying 3 Results")
      expect(page).not_to have_content("Load More")
      expect(page).to have_content("Displaying 3 / 3 Results")
    end

    it "navigates to last page" do
      stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 2)
      create(:video, :display)
      create(:video, :display)
      create(:video, :display)
      visit videos_path

      expect(page).to have_content("Displaying 3 Results")
      click_on("Load More")
      expect(page).not_to have_content("Load More")
      expect(page).to have_content("Displaying 3 Results")
      expect(page).to have_content("Displaying 3 / 3 Results")
    end
  end
end
