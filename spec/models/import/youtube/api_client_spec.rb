# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::Youtube::ApiClient do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "#video_metadata" do
    before do
      stub_yt_gem
    end

    it "returns correct video metadata" do
      metadata = Import::Youtube::ApiClient.new.metadata(slug)

      expect(metadata.slug).to eq slug
      expect(metadata.title).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.description).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.upload_date).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.tags).to match_array ["Academia de Tango", "Amsterdam", "Nederland", "Netherlands", "Salon de los Sabados", "espinoza", "hurtado", "hurtado espinoza", "milonga", "noelia", "noelia hurtado", "tango", "argentinian tango", "carlitos espinoza", "carlos espinoza"]
      expect(metadata.duration).to eq 167
      expect(metadata.hd).to be true
      expect(metadata.view_count).to eq 1051
      expect(metadata.favorite_count).to eq 0
      expect(metadata.comment_count).to eq 0
      expect(metadata.like_count).to eq 3
      expect(metadata.thumbnail_url.default).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/default.jpg"
      expect(metadata.thumbnail_url.medium).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/mqdefault.jpg"
      expect(metadata.thumbnail_url.high).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/hqdefault.jpg"
      expect(metadata.thumbnail_url.standard).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/sddefault.jpg"
      expect(metadata.thumbnail_url.maxres).to eq "https://i.ytimg.com/vi/AQ9Ri3kWa_4/maxresdefault.jpg"
      expect(metadata.channel.id).to eq "UCvnY4F-CJVgYdQuIv8sqp-A"
      expect(metadata.channel.title).to eq "jkuklaVideo"
      expect(metadata.channel.thumbnail_url).to eq "https://yt3.ggpht.com/ytc/AGIKgqNvE9cMPwoXCaUyjV4oJehuFDIgVn9hstLYDHgL=s88-c-k-c0x00ffffff-no-rj"
    end
  end

  def stub_yt_gem
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=#{Config.youtube_api_key!}&part=snippet").to_return(body: file_fixture("yt_gem_api_response.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=#{Config.youtube_api_key!}&maxResults=50&part=contentDetails").to_return(body: file_fixture("yt_gem_api_response_1.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=#{Config.youtube_api_key!}&maxResults=50&part=statistics").to_return(body: file_fixture("yt_gem_api_response_2.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/channels?id=UCvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&part=snippet").to_return(body: file_fixture("yt_gem_api_response_3.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/channels?id=UCvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&maxResults=50&part=statistics").to_return(body: file_fixture("yt_gem_api_response_4.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/channels?id=UCvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&part=contentDetails").to_return(body: file_fixture("yt_gem_api_response_5.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlists?id=,UUvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&maxResults=50&part=snippet,status").to_return(body: file_fixture("yt_gem_api_response_6.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{Config.youtube_api_key!}&maxResults=50&part=snippet,status&playlistId=UCvnY4F-CJVgYdQuIv8sqp-A").to_return(body: file_fixture("yt_gem_api_response_7.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlists?channelId=UCvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&maxResults=50&part=snippet,status").to_return(body: file_fixture("yt_gem_api_response_8.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/subscriptions?channelId=UCvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&maxResults=50&part=snippet").to_return(body: file_fixture("yt_gem_api_response_9.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/channels?id=UCvnY4F-CJVgYdQuIv8sqp-A&key=#{Config.youtube_api_key!}&part=status").to_return(body: file_fixture("yt_gem_api_response_10.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{Config.youtube_api_key!}&maxResults=50&part=snippet,status&playlistId=UUvnY4F-CJVgYdQuIv8sqp-A").to_return(body: file_fixture("yt_gem_api_response_11.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{Config.youtube_api_key!}&maxResults=50&pageToken=EAAaBlBUOkNESQ&part=snippet,status&playlistId=UUvnY4F-CJVgYdQuIv8sqp-A").to_return(body: file_fixture("yt_gem_api_response_12.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{Config.youtube_api_key!}&maxResults=50&pageToken=EAAaBlBUOkNHUQ&part=snippet,status&playlistId=UUvnY4F-CJVgYdQuIv8sqp-A").to_return(body: file_fixture("yt_gem_api_response_13.json").read)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/playlistItems?key=#{Config.youtube_api_key!}&maxResults=50&pageToken=EAAaB1BUOkNKWUI&part=snippet,status&playlistId=UUvnY4F-CJVgYdQuIv8sqp-A").to_return(body: file_fixture("yt_gem_api_response_14.json").read)
  end
end
