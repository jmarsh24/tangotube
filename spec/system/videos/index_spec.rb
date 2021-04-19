require "rails_helper"

RSpec.describe "Videos::Index", type: :system do
  it "shows videos, display and populates filters" do
    setup_videos
    shows_videos
    toggle_filters_hidden
    sorts_videos

    display_filters
    links_to_videos
    create_empty_selects

    populate_filters
    filters_videos
  end

  def setup_videos
    leader = create(:leader, name: "leader_name")
    follower = create(:follower, name: "follower_name")
    song_a = create(:song, artist: "artist_name_a", last_name_search: "A", title: "song_title_a", genre: "genre_a")
    song_b = create(:song, artist: "artist_name_b", last_name_search: "B", title: "song_title_b", genre: "genre_b")
    song_c = create(:song, artist: "artist_name_c", last_name_search: "C", title: "song_title_c", genre: "genre_c")
    event_a = create(:event, title: "event_a")
    event_b = create(:event, title: "event_b")
    event_c = create(:event, title: "event_c")
    channel_a = create(:channel, title: "channel_a")
    channel_b = create(:channel, title: "channel_b")
    channel_c = create(:channel, title: "channel_c")
    create(:video, :display, title: "video_a", view_count: "1", like_count: "1", popularity: "3", upload_date: "2000-01-01",
                      youtube_id: "youtube_id_a", duration: "30", hd: "0", song: song_a, channel: channel_a, event: event_a, leader: leader)
    create(:video, :display, title: "video_b", view_count: "2", like_count: "2", popularity: "2", upload_date: "1999-01-01",
                      youtube_id: "youtube_id_b", duration: "60", hd: "1", song: song_b, channel: channel_b, event: event_b, follower: follower)
    create(:video, :display, title: "video_c", view_count: "3", like_count: "3", popularity: "1", upload_date: "1998-01-01",
                      youtube_id: "youtube_id_c", duration: "90", hd: "1", song: song_c, channel: channel_c, event: event_c)
  end

  def display_filters
    display_hd_all_buttons
    display_sort_options
  end

  def filters_videos
    filter_by_hd
  end

  def sorts_videos
    sort_by_song_title
    sort_by_channel
    sort_by_orchestra
    sort_by_view_count
    sort_by_upload_date
  end

  def links_to_videos
    filter_by_video_song_id
    filter_by_video_channel_id
    filter_by_video_event_id
    visit_video_thumbnail_link
    visit_video_title_link
  end

  def paginated_videos
    load_more_button_present
    load_more_button_hidden
  end

  def shows_videos
    visit videos_path
    click_on("Popularity")
    click_on("Popularity")
    display_video_thumbnails
    display_video_thumbnail_details
    display_channel_titles
    display_video_song
    display_video_event_title
    display_video_metadata

    expect(page).to have_content("Displaying 3 / 3 Results")
  end

  def video_thumbnail_collection
    page.all("img.thumbnail-image").map { |img| img["src"] }
  end

  def video_thumnbail_details_collection
    page.all("div.thumbnail").map { |data| data["data-duration"] }
  end

  def video_title_collection
    page.all("div.video-title").map(&:text)
  end

  def video_metadata_collection
    page.all("div.video-metadata").map(&:text)
  end

  def video_event_title_collection
    page.all("div.video-event").map(&:text)
  end

  def video_channel_titles_collection
    page.all("div.video-channel").map(&:text)
  end

  def video_metadata_collection
    page.all("div.video-metadata").map(&:text)
  end

  def video_song_collection
    page.all("div.video-song").map(&:text)
  end

  def display_video_thumbnails
    expect(video_thumbnail_collection).to eq(["https://img.youtube.com/vi/youtube_id_a/hqdefault.jpg",
                                              "https://img.youtube.com/vi/youtube_id_b/hqdefault.jpg",
                                              "https://img.youtube.com/vi/youtube_id_c/hqdefault.jpg"])
  end

  def display_video_thumbnail_details
    expect(video_thumnbail_details_collection).to eq(["00:30", "HD 01:00", "HD 01:30"])
  end

  def display_channel_titles
    expect(video_channel_titles_collection).to eq(%w[channel_a channel_b channel_c])
  end

  def display_video_song
    expect(video_song_collection).to eq(["Song Title A - Artist Name A - Genre A",
                                         "Song Title B - Artist Name B - Genre B",
                                         "Song Title C - Artist Name C - Genre C"])
  end

  def display_video_event_title
    expect(video_event_title_collection).to eq(["Event A", "Event B", "Event C"])
  end

  def display_video_metadata
    expect(video_metadata_collection).to eq(["January 2000 • 1 views • 1 likes",
                                             "January 1999 • 2 views • 2 likes",
                                             "January 1998 • 3 views • 3 likes"])
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

  def populate_filters
    click_on("Popularity")

    expect(page).to have_select("genre-filter", with_options: ["", "Genre A (1)", "Genre B (1)", "Genre C (1)"])
    expect(page).to have_select("leader-filter", with_options: ["", "Leader Name (1)"])
    expect(page).to have_select("follower-filter", with_options: ["", "Follower Name (1)"])
    expect(page).to have_select("orchestra-filter", with_options: ["", "Artist Name A (1)", "Artist Name B (1)", "Artist Name C (1)"])
    expect(page).to have_select("year-filter", with_options: ["", "2000 (1)", "1999 (1)", "1998 (1)"])
  end

  def filters_videos; end

  def create_empty_selects
    expect(page).to have_select("genre-filter")
    expect(page).to have_select("leader-filter")
    expect(page).to have_select("follower-filter")
    expect(page).to have_select("orchestra-filter")
    expect(page).to have_select("year-filter")
  end

  def toggle_filters_hidden
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
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
    click_on("Upload Date")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
  end

  def sort_by_orchestra
    click_on("Orchestra")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
    click_on("Orchestra")
    expect(video_title_collection).to eq(%w[video_a video_b video_c])
  end

  def load_more_button_present
    stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 2)
    visit videos_path
    expect(page).to have_content("Displaying 2 / 3 Results")
    click_on("Load More")
    expect(page).not_to have_content("Load More")
    expect(page).to have_content("Displaying 3 / 3 Results")
  end

  def load_more_button_hidden
    stub_const("Video::Search::NUMBER_OF_VIDEOS_PER_PAGE", 5)
    visit videos_path
    expect(page).not_to have_content("Load More")
    expect(page).to have_content("Displaying 3 / 3 Results")
  end

  def filter_by_hd
    click_on("HD")
    expect(video_title_collection).to eq(%w[video_b video_c])
    click_on("All")
    click_on("Popularity")
    expect(video_title_collection).to eq(%w[video_c video_b video_a])
  end

  def filter_by_video_song_id
    click_on("Song Title A - Artist Name A - Genre A")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_video_channel_id
    click_on("channel_a")
    expect(video_title_collection).to eq(["video_a"])
  end

  def filter_by_video_event_id
    click_on("Event A")
    expect(video_title_collection).to eq(["video_a"])
  end

  def visit_video_thumbnail_link
    click_on("Popularity")
    all("a#video-link").first.click
    expect(current_url).to eq("http://www.example.com/watch?v=youtube_id_a")
    visit videos_path
  end

  def visit_video_title_link
    click_on("Popularity")
    click_on("video_a")
    expect(current_url).to eq("http://www.example.com/watch?v=youtube_id_a")
    visit videos_path
  end
end

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
