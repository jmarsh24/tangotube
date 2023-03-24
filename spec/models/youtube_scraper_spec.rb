# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeScraper do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "video_metadata" do
    it "returns the video metadata from youtube", vcr: {record: :new_episodes} do
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
      expect(metadata.view_count).to eq 1050
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
      expect(metadata.channel.id).to eq "UCvnY4F-CJVgYdQuIv8sqp-A"
      expect(metadata.channel.title).to eq "jkuklaVideo"
      expect(metadata.channel.description).to eq ""
      expect(metadata.channel.published_at).to eq "2012-05-21 12:31:41.000000000 +0000"
      expect(metadata.channel.thumbnail_url).to eq "https://yt3.ggpht.com/ytc/AL5GRJWaKWUq-2aJhzwmgH7VQ-mkxXcySvtGB7Oge3kh=s88-c-k-c0x00ffffff-no-rj"
      expect(metadata.channel.view_count).to eq 304130
      expect(metadata.channel.video_count).to eq 169
      expect(metadata.channel.subscriber_count).to eq 389
      expect(metadata.channel.videos).to match_array ["tVmD4x0NtsE", "l4gmmR6BGY4", "yHIcLs4U7ws", "_7mHTtKKvtw", "0ZPR_DNTghE", "iOieQi7iYwA", "vVz4dqCc2lc", "H2Q9jFGNC94", "NA-muRg2jyk", "rX7CsSnqAp4", "bnIG3wVZ52Q", "FnPa-M9Ezos", "fN4ThtBSiU8", "3O33gHJGibQ", "w_GxmSMfyvE", "LTptQYCisJk", "xzucEZx6c_E", "6cZR3kIpCu8", "BLMr09iTLjQ", "m8-A40Ka-6o", "45ewSNMOmgg", "3yqrzTc0Yks", "ZRtWN_ObKss", "vuMhamQnR7g", "smP1skkGaZ4", "f3W-6nZFdKI", "MrRps8_81zI", "ADoxqxI_1FE", "oq2idlPLbco", "Z3WH6bskQ5s", "pZWkNG3KNqU", "61XJi__UDRw", "6PS6iopv7aY", "icNgKwNvfpc", "Hx0iHLSyOx8", "R_55celtOVk", "iDs8BWLjayQ", "IS041D8_vEg", "Y5do7v2jfEk", "cnV_X9gpb7Y", "NAjXs-LbbQ8", "kf2LAC6l0Lc", "a9rYjjxTwVM", "Pc8P1OaBSuc", "2MMD1Nj7XC4", "hNljorURqk0", "om-RMGuLCII", "yCZbZU0SJaM", "iRTN5C4pxM0", "uYYP1UMKGbU", "nGA7-iw6Pag", "miJO8BGq0Pg", "MQ96oN4AnKw", "AQ9Ri3kWa_4", "fPpxadIpZn4", "yQlzSz8NxBw", "WjDtsHd1kQo", "Sh33tRdhZMc", "d0eTEJSxTys", "qEEbxV-EF30", "5fKDEpdtS3g", "6-Uh51vY8Ns", "tibpTW6S45Y", "tduA8NDGiQc", "btvgHRHHW3o", "hg92xp5Z7-s", "ouf8iHvgSLM", "PiJMRE6kLZo", "ZjwnFQ3_AUE", "nHeuvvtwBis", "K6B-nJKhpq8", "IYJbdMXsZoA", "ZgdNe1kDDpM", "Ottqa5ldhVs", "Da3OZ3KkfoE", "7sNdy8ra8hY", "jnVUEit-cGI", "I55-js1JMew", "rrrruwk6i3M", "8e2qLFaZ66A", "SyPNezfK_Vc", "JASvQhndy5k", "upObe9-knqs", "y9PRc4c-b74", "Uibflwv5Hu8", "5gRtvN86lMY", "t3vj1tVZTKY", "7o5Q4ca4pTQ", "Dm6jSNRBQlQ", "cu6lKr327Y4", "9jV7T3QHpLw", "O4ba-v8aC9M", "SSAgQwWSvJM", "Roax53-5Nl4", "Bvenu1BtLQ8", "y3lr5NBxEoU", "QCqrW3dcZOU", "Vmw5CqLTD6g", "TLb0W1ETF9Q", "QXLdz0QLYX0", "lOHWXsK61Xc", "exuiY-AKV8E", "59YdBBAMB7U", "WgsTkX6Pu8M", "ga7ZIlLEegc", "xkewduSP8JI", "imr97YXB0tc", "HI6ekleA9F4", "5jSZXhIcRWY", "R7K_b52gmZQ", "cpec_0AOgO8", "ii9P3T1H4QE", "uKD5z4RtF-M", "6fcXUa6F270", "SH9Lf0GUTEg", "sWsK_ayBQyo", "5zWDjyl2Kys", "Upuz-0L5MXo", "UdgVYNAcK20", "R9ohv5xZ6sk", "ciOvuBg5EYo", "py-KWtzv4W0", "yz5jLqtzL6A", "OGq7nXdeJc4", "9BJLqKhjqyc", "AqNEFw2fPDk", "P9kJmtknRhY", "p17JcmoNDqo", "LnuO70hYnjA", "K57o9q-awRs", "rnKtdlbFpqk", "ofywhpA8mb4", "9w6pOKKGNbk", "ActDtfycs2M", "VpP0v-r_Gsk", "YSvFSZq3wmA", "3IjygrbAgIY", "HYs6X7y5hII", "i93p4QEicds", "Paf3v1uX6rk", "57uMWB660JE", "g99OMLy4fNo", "ADjp1pEAAaQ", "hhPrkrRCdm4", "QcSdaKSytYM", "D2s4nTBZ7OE", "3aq9rojukCI", "lyDursWZcmc", "bR-38FZUhPE", "_OKnDDklseg", "2iDCsBOxyog", "svko-JfEbII", "AD-tc4VCzLk", "1SxIY_YTHG0", "PaBYAgLRC7E", "AxKYqg4LLQk", "-5RiJFLqnU0", "RN3NCatyVgo", "2O1aR6AaDmc", "B2zwNr7W99k", "WaL49t7_uJI", "PfY_N_ZTuWM", "Iw7g0DBva5g", "Ii5rdG3qZYY", "G9XdYlLMkgI", "TY19lt-0y4w", "MI7sh6nqlgE", "iwAAmcLdDiI", "GwUy5nAPIIU"]
      expect(metadata.channel.playlists).to match_array ["PLRD0WLQrCTH6vNFIFqgvOgawZQhJYkPQJ", "PLRD0WLQrCTH660DN4kTqOR0uSSYWa9wfq", "PLRD0WLQrCTH78YBEKYbodQByZoirUPfrD", "PLRD0WLQrCTH4QIJfHBuCBzi7Ia_CPQazq", "PLRD0WLQrCTH6g2iyoGDvbnrLy6G0N5wjS", "PLRD0WLQrCTH7ck5q9m8o-YoS6VdBZGjkG", "PLRD0WLQrCTH5iyqTONvJIwxgHaNpif0Qa", "PLRD0WLQrCTH4EsMsS1XRjMOjRqpPBitrJ", "PLRD0WLQrCTH4InlDZGtGwKkKv9L4LcHAL", "PLRD0WLQrCTH6Tk8oSu2jPQhbAwxbMbFH4", "PLRD0WLQrCTH403nA7DinafFp-wDebfp3b", "PLRD0WLQrCTH6Z8evcxrR1YFXqVeXFIInx", "PLRD0WLQrCTH71poYcbor-C0v2T3Ss5RMy", "PLRD0WLQrCTH7PMx0jIqceeFDz7nUQC-zY", "PLRD0WLQrCTH4tBOPno_kCnAHAru9ks_IT", "PLRD0WLQrCTH4Xqx5-Jh72D9ZrI62vp3KD", "PLRD0WLQrCTH6BUwoOVWE-U4urnbKM4vxU", "PLRD0WLQrCTH6K7E2hLPHO1m4jNnu29cS1", "PLRD0WLQrCTH4Bfh4nooISrnSQff_iJl6A", "PLRD0WLQrCTH5shZ8vQjl22v3STOclCqk3", "PLRD0WLQrCTH7TVYzmwRS7ZFnerhPF4ier", "PLRD0WLQrCTH4Rr8LwSe3BPN4Mo4HRO7XG", "PLRD0WLQrCTH77l3JN7Qw4j5ECbZGpFp16", "PLRD0WLQrCTH6W_u2qdH-3AgV2itgIfKNC", "PLRD0WLQrCTH4cfarv1DGqXZ05xrcC4v0O", "PLRD0WLQrCTH7nZqmBPryLE0tabMTwOGth", "PLRD0WLQrCTH5BEvfSa12x4U60d3GDhdkB", "PLRD0WLQrCTH4ctWc3hshxhv0s0I_2zU8f", "PLRD0WLQrCTH7Lr3YDga0Z8LeCicHwDDYg", "PLRD0WLQrCTH7hU_QjX_GMfhUXUQ4OLka0", "PLRD0WLQrCTH6To1XS3EFEmgyECeO9dSV7", "PLRD0WLQrCTH7EK9MC_APrlocgx51EAA6L", "PLRD0WLQrCTH7rnaA8eNL7FYh5E6LbgFcF", "PLRD0WLQrCTH73gquO5ZdDLKYv58Q5mfLH", "PLRD0WLQrCTH6rerU2Ox38Ltf3P6Tg9ToP", "PLRD0WLQrCTH6AS-X1gT-PttyakusdgvCg"]
      expect(metadata.channel.related_playlists).to match_array ["UUvnY4F-CJVgYdQuIv8sqp-A"]
      expect(metadata.channel.subscribed_channels).to match_array ["UCbFu9bCnKZhBeDUYlBVtnjQ"]
      expect(metadata.channel.subscriber_count).to eq 389
      expect(metadata.channel.privacy_status).to eq "public"
    end
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
    allow(music_row_item_node).to receive(:all_text).with(no_args).and_return nil
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
