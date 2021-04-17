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

  describe "footer" do
    it "has footer content" do
      visit videos_path
      expect(page).to have_content("TangoTubeTV App | Powered by Youtube API")
      expect(page).to have_link("Privacy Policy", href: privacy_path)
      expect(page).to have_link("Terms of Service", href: terms_path)
      expect(page).to have_link("G​oogle Privacy Policy", href: "http://www.google.com/policies/privacy")
    end
  end

end
