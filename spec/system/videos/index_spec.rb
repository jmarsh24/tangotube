require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
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
      visit new_user_session_path

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
      visit new_user_session_path

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
      visit new_user_session_path

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
      #   driven_by(:selenium)
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

    it "populates genre filter" do
      song_tango = create(:song, genre: "Tango")
      song_milonga = create(:song, genre: "Milonga")
      create(:video, :display, song: song_tango)
      create(:video, :display, song: song_tango)
      create(:video, :display, song: song_milonga)

      visit videos_path

      expect(page).to have_select("genre-filter", options: ["", "Tango (2)", "Milonga (1)"])
    end

    it "filters videos by genre", js: true do
      song_tango = create(:song, genre: "Tango")
      song_milonga = create(:song, genre: "Milonga")
      create(:video, :display, song: song_tango, title: "Tango Video")
      create(:video, :display, song: song_tango, title: "Tango Video")
      create(:video, :display, song: song_milonga, title: "Milonga Video")
      visit videos_path

      find("div.ss-option", text: "Milonga (1)").click

      # expect(page).to have_select("genre-filter", selected: "Milonga (1)")
      # expect(page).not_to have_select("genre-filter", options: ["Tango (2)"])
      expect(page).to have_content("Milonga Video")
      expect(page).not_to have_content("Tango Video")
    end

    it "populates Leader filter" do
      leader1 = create(:leader, name: "Carlitos Espinoza")
      leader2 = create(:leader, name: "Chicho Frumboli")
      create(:video, :display, leader: leader1)
      create(:video, :display, leader: leader1)
      create(:video, :display, leader: leader2)
      visit videos_path

      expect(page).to have_select("leader-filter", options: ["", "Carlitos Espinoza (2)", "Chicho Frumboli (1)"])
    end

    it "populates Follower filter" do
      follower1 = create(:follower, name: "Noelia Hurado")
      follower2 = create(:follower, name: "Roxana Suarez")
      create(:video, :display, follower: follower1)
      create(:video, :display, follower: follower1)
      create(:video, :display, follower: follower2)
      visit videos_path

      expect(page).to have_select("follower-filter", options: ["", "Noelia Hurado (2)", "Roxana Suarez (1)"])
    end

    it "populates Orchestra filter" do
      song1 = create(:song, artist: "Osvaldo Pugliese")
      song2 = create(:song, artist: "Carlos Di Sarli")
      create(:video, :display, song: song1)
      create(:video, :display, song: song1)
      create(:video, :display, song: song2)
      visit videos_path

      expect(page).to have_select("orchestra-filter", options: ["", "Osvaldo Pugliese (2)", "Carlos Di Sarli (1)"])
    end

    it "populates Year filter" do
      create(:video, :display, upload_date: "2017-5-1")
      create(:video, :display, upload_date: "2017-10-26")
      create(:video, :display, upload_date: "2018-1-2")
      visit videos_path

      expect(page).to have_select("year-filter", options: ["", "2017 (2)", "2018 (1)"])
    end
  end

  describe "footer" do
    it "has footer content" do
      visit videos_path
      expect(page).to have_content("TangoTubeTV App | Powered by Youtube API")
      expect(page).to have_link("Privacy Policy", href: privacy_path)
      expect(page).to have_link("Terms of Service", href: terms_path)
      expect(page).to have_link("G​oogle Privacy Policy", href: "http://www.google.com/policies/privacy")
    end
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
      visit videos_path

      expect(page).to have_content("Displaying 2 Results")
      expect(page).not_to have_content("Load More")
      expect(page).to have_content("Displaying 2 / 2 Results")
    end

    it "navigates to last page" do
      stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 1)
      create(:video, :display)
      create(:video, :display)
      visit videos_path

      expect(page).to have_content("Displaying 2 Results")
      expect(page).to have_content("Displaying 1 / 2 Results")
      click_on("Load More")
      expect(page).not_to have_content("Load More")
      expect(page).to have_content("Displaying 2 Results")
      expect(page).to have_content("Displaying 2 / 2 Results")
    end
  end
end
