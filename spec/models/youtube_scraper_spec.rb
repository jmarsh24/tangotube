# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeScraper do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "video_metadata" do
    fit "returns the video metadata from youtube" do
      stub_youtube_api

      driver = Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})

      youtube_scraper = YoutubeScraper.new(driver:)

      stub_const("YoutubeScraper::RETRY_COUNT", 0)
      stub_page(driver)
      stub_music_row_selector_mutiple_parsing(driver)
      stub_recommended_videos_selector_parsing(driver)
      stub_music_row_selector_single_parsing(driver)

      metadata = youtube_scraper.video_metadata slug

      expect(metadata.slug).to eq slug
      expect(metadata.title).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.description).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.upload_date).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.tags).to match_array ["Academia de Tango", "Amsterdam", "Nederland", "Netherlands", "Salon de los Sabados", "espinoza", "hurtado", "hurtado espinoza", "milonga", "noelia", "noelia hurtado", "tango", "argentinian tango", "carlitos espinoza", "carlos espinoza"]
      expect(metadata.duration).to eq 167
      expect(metadata.hd).to eq true
      expect(metadata.view_count).to eq 1046
      expect(metadata.favorite_count).to eq 0
      expect(metadata.comment_count).to eq 0
      expect(metadata.like_count).to eq 3
      expect(metadata.thumbnail_url.default).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/default.jpg"
      expect(metadata.thumbnail_url.medium).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/mqdefault.jpg"
      expect(metadata.thumbnail_url.high).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/hqdefault.jpg"
      expect(metadata.thumbnail_url.standard).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/sddefault.jpg"
      expect(metadata.thumbnail_url.maxres).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/maxresdefault.jpg"
      expect(metadata.song.titles).to include "Cuando El Amor Muere"
      expect(metadata.song.artist).to eq "Carlos Di Sarli y su Orquesta Típica"
      expect(metadata.recommended_video_ids).to match_array ["0ZPR_DNTghE", "1weCIypdfkE", "34dYj80KLmU"]
    end
  end

  def stub_youtube_api
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&part=snippet")
      .to_return(status: 200, body: file_fixture("youtube_scraper_response.json").read)

    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&maxResults=50&part=contentDetails")
      .to_return(status: 200, body: file_fixture("youtube_scraper_response_1.json").read)

    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&maxResults=50&part=statistics")
      .to_return(status: 200, body: file_fixture("youtube_scraper_response_2.json").read)
  end

  def stub_page(driver)
    related_node = instance_double Capybara::Cuprite::Node
    allow(driver).to receive(:visit).and_return(nil)
    allow(related_node).to receive(:find).with(:css, "#spinner").and_return [nil]
    allow(driver).to receive(:find).with(:css, "#related").and_return [related_node]
  end

  def stub_music_row_selector_mutiple_parsing(driver)
    music_row_multiple_node = instance_double Capybara::Cuprite::Node
    music_row_item_node = instance_double Capybara::Cuprite::Node
    allow(music_row_item_node).to receive(:all_text).with(no_args).and_return ["Cuando El Amor Muere"]
    allow(music_row_multiple_node).to receive(:find).with(:css, "#video-title").and_return [music_row_item_node]
    allow(driver).to receive(:find).with(:css, "#video-lockups").and_return [music_row_multiple_node]
  end

  def stub_recommended_videos_selector_parsing(driver)
    recommended_videos_node_1 = instance_double Capybara::Cuprite::Node
    recommended_videos_node_2 = instance_double Capybara::Cuprite::Node
    recommended_videos_node_3 = instance_double Capybara::Cuprite::Node
    allow(recommended_videos_node_1).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=0ZPR_DNTghE"
    allow(recommended_videos_node_2).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=1weCIypdfkE"
    allow(recommended_videos_node_3).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=34dYj80KLmU"
    allow(driver).to receive(:find).with(:css, ".ytd-thumbnail").and_return [recommended_videos_node_1, recommended_videos_node_2, recommended_videos_node_3]
  end

  def stub_music_row_selector_single_parsing(driver)
    music_album_row_node = instance_double Capybara::Cuprite::Node
    music_album_attribute_node = instance_double Capybara::Cuprite::Node
    music_album_value_node = instance_double Capybara::Cuprite::Node
    music_artist_row_node = instance_double Capybara::Cuprite::Node
    music_artist_attribute_node = instance_double Capybara::Cuprite::Node
    music_artist_value_node = instance_double Capybara::Cuprite::Node
    music_song_row_node = instance_double Capybara::Cuprite::Node
    music_song_attribute_node = instance_double Capybara::Cuprite::Node
    music_song_value_node = instance_double Capybara::Cuprite::Node
    music_writers_row_node = instance_double Capybara::Cuprite::Node
    music_writers_attribute_node = instance_double Capybara::Cuprite::Node
    music_writers_value_node = instance_double Capybara::Cuprite::Node

    allow(music_album_value_node).to receive(:all_text).with(no_args).and_return "Cuando El Amor Muere"
    allow(music_album_attribute_node).to receive(:all_text).with(no_args).and_return "album"
    allow(music_album_value_node).to receive(:find).with(:css, "a").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_album_row_node).to receive(:find).with(:css, "a").and_return [music_album_attribute_node]
    allow(music_album_row_node).to receive(:find).with(:css, "#title").and_return [music_album_attribute_node]
    allow(music_album_row_node).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_album_row_node).to receive(:find).with(:css, "a").and_return [music_album_attribute_node]
    allow(music_album_row_node).to receive(:find).with(:css, "#title").and_return [music_album_attribute_node]
    allow(music_album_row_node).to receive(:find).with(:css, "#default-metadata").and_return [music_album_value_node]

    allow(music_artist_value_node).to receive(:all_text).with(no_args).and_return "Carlos Di Sarli y su Orquesta Típica"
    allow(music_artist_attribute_node).to receive(:all_text).with(no_args).and_return "artist"
    allow(music_artist_value_node).to receive(:find).with(:css, "a").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_artist_row_node).to receive(:find).with(:css, "a").and_return [music_artist_attribute_node]
    allow(music_artist_row_node).to receive(:find).with(:css, "#title").and_return [music_artist_attribute_node]
    allow(music_artist_row_node).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_artist_row_node).to receive(:find).with(:css, "a").and_return [music_artist_attribute_node]
    allow(music_artist_row_node).to receive(:find).with(:css, "#title").and_return [music_artist_attribute_node]
    allow(music_artist_row_node).to receive(:find).with(:css, "#default-metadata").and_return [music_artist_value_node]

    allow(music_song_value_node).to receive(:all_text).with(no_args).and_return "Cuando El Amor Muere"
    allow(music_song_attribute_node).to receive(:all_text).with(no_args).and_return "song"
    allow(music_song_value_node).to receive(:find).with(:css, "a").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_song_row_node).to receive(:find).with(:css, "a").and_return [music_song_attribute_node]
    allow(music_song_row_node).to receive(:find).with(:css, "#title").and_return [music_song_attribute_node]
    allow(music_song_row_node).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_song_row_node).to receive(:find).with(:css, "a").and_return [music_song_attribute_node]
    allow(music_song_row_node).to receive(:find).with(:css, "#title").and_return [music_song_attribute_node]
    allow(music_song_row_node).to receive(:find).with(:css, "#default-metadata").and_return [music_song_value_node]

    allow(music_writers_value_node).to receive(:all_text).with(no_args).and_return "Cuando El Amor Muere"
    allow(music_writers_attribute_node).to receive(:all_text).with(no_args).and_return "writers"
    allow(music_writers_value_node).to receive(:find).with(:css, "a").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_writers_row_node).to receive(:find).with(:css, "a").and_return [music_writers_attribute_node]
    allow(music_writers_row_node).to receive(:find).with(:css, "#title").and_return [music_writers_attribute_node]
    allow(music_writers_row_node).to receive(:[]).with("href").and_return "https://www.youtube.com/watch?v=AQ9Ri3kWa_4"
    allow(music_writers_row_node).to receive(:find).with(:css, "a").and_return [music_writers_attribute_node]
    allow(music_writers_row_node).to receive(:find).with(:css, "#title").and_return [music_writers_attribute_node]
    allow(music_writers_row_node).to receive(:find).with(:css, "#default-metadata").and_return [music_writers_value_node]

    allow(driver).to receive(:find).with(:css, "#info-row-header").and_return [music_album_row_node, music_song_row_node, music_artist_row_node, music_writers_row_node]
  end
end
