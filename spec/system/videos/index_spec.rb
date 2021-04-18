require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
  describe "filters" do
    it "shows videos, display and populates filters" do
      setup_videos
      shows_videos
      display_filters
      populate_filters
      toggle_hidden
      create_empty_selects
      sort_by_song_title
      sort_by_channel
      sort_by_orchestra
      sort_by_view_count
      sort_by_upload_date
    end

    def setup_videos
      song1 = create(:song, last_name_search: "A", title: "A")
      song2 = create(:song, last_name_search: "B", title: "B")
      song3 = create(:song, last_name_search: "C", title: "C")
      channel1 = create(:channel, title: "A")
      channel2 = create(:channel, title: "B")
      channel3 = create(:channel, title: "C")
      video1 = create(:video, :display, title: "video_a", view_count: "1", upload_date: "2000-01-01", song: song1, channel: channel1)
      video2 = create(:video, :display, title: "video_b", view_count: "2", upload_date: "1999-01-01", song: song2, channel: channel2)
      video3 = create(:video, :display, title: "video_c", view_count: "3", upload_date: "1998-01-01", song: song3, channel: channel3)
    end

    def shows_videos
      visit videos_path
      # expect(page).to have_content("probably should test for the video name, and whatever else you should...")
      expect(page).to have_content("Displaying 3 / 3 Results")
    end

    def display_filters
      display_hd_all_buttons
      display_sort_options
    end

    def display_hd_all_buttons
      expect(page).to have_content("HD")
      expect(page).to have_content("All")
    end

    def display_sort_options
      expect(page).to have_content("Song Title")
      expect(page).to have_content("Orchestra")
      expect(page).to have_content("Channel")
      expect(page).to have_content("View Count")
      expect(page).to have_content("Upload Date")
    end

    def populate_filters; end

    def filters_videos; end

    def create_empty_selects
      expect(page).to have_select("genre-filter")
      expect(page).to have_select("leader-filter")
      expect(page).to have_select("follower-filter")
      expect(page).to have_select("orchestra-filter")
      expect(page).to have_select("year-filter")
    end

    def toggle_hidden
      expect(page).to have_css("div.filter-container")
      click_on("Filters")
      expect(page).not_to have_css("div.filter-container isHidden")
    end

    def sort_by_song_title
      click_on("Song Title")
      expect(video_title_collection).to eq(%w[video_c video_b video_a])
      click_on("Song Title")
      expect(video_title_collection).to eq(%w[video_a video_b video_c])
    end

    def sort_by_channel
      click_on("Channel")
      expect(video_title_collection).to eq(%w[video_c video_b video_a])
      click_on("Channel")
      expect(video_title_collection).to eq(%w[video_a video_b video_c])
    end

    def sort_by_view_count
      click_on("View Count")
      expect(video_title_collection).to eq(%w[video_c video_b video_a])
      click_on("View Count")
      expect(video_title_collection).to eq(%w[video_a video_b video_c])
    end

    def sort_by_upload_date
      click_on("Upload Date")
      expect(video_title_collection).to eq(%w[video_c video_b video_a])
      click_on("Upload Date")
      expect(video_title_collection).to eq(%w[video_a video_b video_c])
    end

    def sort_by_orchestra
      click_on("Orchestra")
      expect(video_title_collection).to eq(%w[video_c video_b video_a])
      click_on("Orchestra")
      expect(video_title_collection).to eq(%w[video_a video_b video_c])
    end

    def video_title_collection
      page.all("div.video-title").map(&:text)
    end
  end
end

#   it "sorts videos" do
#     def setup_videos; end

#     def sorts_song_title
#       # click_on "Orchestra"
#     end

#     def sorts_song_title
#       # click_on "View Count"
#     end

#     def sorts_song_title
#       # click_on "Upload Date"
#     end
#   end
# end

#   it "sorts videos DESC" do
#     click_on "Song Title"
#     click_on "Orchestra"
#     click_on "Channel"
#     click_on "View Count"
#     click_on "Upload Date"
#   end

#   it "populates genre filter" do
#     song_tango = create(:song, genre: "Tango")
#     song_milonga = create(:song, genre: "Milonga")
#     create(:video, :display, song: song_tango)
#     create(:video, :display, song: song_tango)
#     create(:video, :display, song: song_milonga)

#     visit videos_path

#     expect(page).to have_select("genre-filter", options: ["", "Tango (2)", "Milonga (1)"])
#   end

#   it "filters videos by genre", js: true do
#     song_tango = create(:song, genre: "Tango")
#     song_milonga = create(:song, genre: "Milonga")
#     create(:video, :display, song: song_tango, title: "Tango Video")
#     create(:video, :display, song: song_tango, title: "Tango Video")
#     create(:video, :display, song: song_milonga, title: "Milonga Video")
#     visit videos_path

#     find("div.ss-option", text: "Milonga (1)").click

#     # expect(page).to have_select("genre-filter", selected: "Milonga (1)")
#     # expect(page).not_to have_select("genre-filter", options: ["Tango (2)"])
#     expect(page).to have_content("1 Result Found")
#     expect(page).to have_content("Displaying 1 / 1 Results")
#     expect(page).to have_content("Milonga Video")
#     expect(page).not_to have_content("Tango Video")
#   end

#   it "populates Leader filter" do
#     leader1 = create(:leader, name: "Carlitos Espinoza")
#     leader2 = create(:leader, name: "Chicho Frumboli")
#     create(:video, :display, leader: leader1)
#     create(:video, :display, leader: leader1)
#     create(:video, :display, leader: leader2)
#     visit videos_path

#     expect(page).to have_select("leader-filter", options: ["", "Carlitos Espinoza (2)", "Chicho Frumboli (1)"])
#   end

#   it "populates Follower filter" do
#     follower1 = create(:follower, name: "Noelia Hurado")
#     follower2 = create(:follower, name: "Roxana Suarez")
#     create(:video, :display, follower: follower1)
#     create(:video, :display, follower: follower1)
#     create(:video, :display, follower: follower2)
#     visit videos_path

#     expect(page).to have_select("follower-filter", options: ["", "Noelia Hurado (2)", "Roxana Suarez (1)"])
#   end

#   it "populates Orchestra filter" do
#     song1 = create(:song, artist: "Osvaldo Pugliese")
#     song2 = create(:song, artist: "Carlos Di Sarli")
#     create(:video, :display, song: song1)
#     create(:video, :display, song: song1)
#     create(:video, :display, song: song2)
#     visit videos_path

#     expect(page).to have_select("orchestra-filter", options: ["", "Osvaldo Pugliese (2)", "Carlos Di Sarli (1)"])
#   end

#   it "populates Year filter" do
#     create(:video, :display, upload_date: "2017-5-1")
#     create(:video, :display, upload_date: "2017-10-26")
#     create(:video, :display, upload_date: "2018-1-2")
#     visit videos_path

#     expect(page).to have_select("year-filter", options: ["", "2017 (2)", "2018 (1)"])
#   end
# end

# describe "navigates to watch page" do
# end

# describe "videos" do
# end

# describe "sorts" do
# end

# describe "pagination" do
#   it "shows last page if next_page empty" do
#     stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 5)
#     create(:video, :display)
#     create(:video, :display)
#     visit videos_path

#     expect(page).not_to have_content("Load More")
#     expect(page).to have_content("Displaying 2 / 2 Results")
#   end

#   it "navigates to last page" do
#     stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 1)
#     create(:video, :display)
#     create(:video, :display)
#     visit videos_path

#     expect(page).to have_content("Displaying 1 / 2 Results")
#     click_on("Load More")
#     expect(page).not_to have_content("Load More")
#     expect(page).to have_content("Displaying 2 / 2 Results")
#   end
# end
