# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeScraper do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  def stub_youtube_api
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&part=snippet")
      .to_return(status: 200, body: file_fixture("youtube_scraper_response.json").read)

    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&maxResults=50&part=contentDetails")
      .to_return(status: 200, body: file_fixture("youtube_scraper_response_1.json").read)

    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=AQ9Ri3kWa_4&key=YOUTUBE_API_KEY&maxResults=50&part=statistics")
      .to_return(status: 200, body: file_fixture("youtube_scraper_response_2.json").read)
  end

  describe "video_metadata" do
    it "returns the video metadata from youtube" do
      stub_youtube_api

      driver = Capybara::Cuprite::Driver.new(app: nil, browser_options: {headless: true})
      # I'm trying to figure out how to mock this part of the test
      youtube_scraper = YoutubeScraper.new(driver:)
      allow(youtube_scraper).to receive(:song).and_return(SongMetadata.new(titles: "Cuando El Amor Muere", artist: "Carlos Di Sarli y su Orquesta Típica"))
      allow(youtube_scraper).to receive(:recommended_videos_ids).and_return(
        ["skypKrzXoMA",
          "Sn7vmyuvFbw",
          "SrZMf_yPI0M",
          "BXoJBry3DHE",
          "C17X0PZNJ8k",
          "q5HreDHJrcY",
          "e-7MNtkR2NM",
          "Nf1CEXsDyzQ",
          "arKaXhmrQsU",
          "mSJeJHq9u_8",
          "TP2sSyUYPnM",
          "k8g-QKho8kA",
          "5Nqnh4BqJMM",
          "nM3-_oHhJew",
          "enUAiJWv_0k",
          "tYxNt459ajk",
          "UhZO1dHv50o",
          "Xkc33HmERRw",
          "gWmP6KHCpJQ",
          "Ut1qvd-jPZk",
          "iLSem3UQbOE",
          "yzhSc21cToE",
          "Z8I6hxAVRdo",
          "p9C7DR1nEcA",
          "Kixb6ZH0xTY",
          "DA94Ava45no",
          "BCWA0ikpHQE",
          "_9qcVo9WP3A",
          "ER2Y2B6u5dw",
          "4RIrJJQypvw",
          "VWd6hY7YCVs",
          "_moxstakXMo",
          "lpVnEChF2xE",
          "1zFokyQkqyA",
          "GaLpdn1g_Hw",
          "CkynwNMS6tk",
          "HPUitIKEUFo",
          "ZDu72AKZYlg",
          "Mkjgu_V4EJU",
          "6YZCeyuu3dA",
          "rjRvjkCE3sw",
          "4HYwJWt3kC8",
          "eWp3xF7Eq7I",
          "XbSAp0gMnhs",
          "J2zyAS7ZCy0",
          "H8P-ACCz0o0",
          "YbQeG79MZFE",
          "GktEoSnDS9g",
          "nXT1RhZg8iE",
          "UW-Ofes7SkY",
          "XMccEHC4dIY",
          "qQwieW1Pr-E",
          "TC7KuyrJBnA",
          "n9VfBkru9h0",
          "s1DmyV4ugpQ",
          "1ZIZNL0RSvM",
          "e6gzOcamOfI",
          "JG1YPyQRl_I",
          "zmxKGnN8R60",
          "2YHmtXg7CdQ",
          "xTKzl1CntuA",
          "VCi6R9XnrQs",
          "PjCZp8UVMqw",
          "-d8TdnEoePA",
          "yO15YlSfdKQ",
          "CvVGVM3JUr8",
          "FaBAM1Q_HfQ",
          "b7DyuUZA8CI",
          "f7TIZxyZnAc",
          "ncE9r5QIP-g",
          "vyQwN0Am534",
          "Z8psWU2W9mI",
          "npINyOt57J4",
          "uWi1nd1ELyU",
          "DeXypKijsLs",
          "F6947SxgMEY",
          "dIjUHVNUku0",
          "u3dWVlb8fgA",
          "v3SSICMBJs0",
          "vNli-79MlHI",
          "NwfGgCtuMsg",
          "SDJPNRKBw3A",
          "osOLoOpjb0w",
          "W3wikk6mrEg",
          "7v_mSY00PzU",
          "STNC56yT6P0",
          "LU_Hjb5cTSU",
          "uoIkXfH50xw",
          "1OBMQCZ2yww",
          "2bIYd8GfIEg",
          "iINDpK4Y09Y",
          "zzpLRd8XuAw",
          "pxm0596FgkE",
          "TT2UGaLLGsk",
          "H5O7ezINPt0",
          "ZhtExMyRuL8",
          "I6bjs8WNiYs",
          "_KE2kSKSjjo",
          "l6pVVvQJuh8",
          "5R6fSdJM7so",
          "bQkd9DKhvg8",
          "wMJgUFYbO-s",
          "I5VGjPv8Lwo",
          "JV4nkFS15O8",
          "mbY0vApu2kY",
          "F2IUn2oOV_c",
          "-qNfcqAiyIo",
          "ATEerUsmcrU"]
      )
      metadata = youtube_scraper.video_metadata(slug)

      expect(metadata.slug).to eq slug
      expect(metadata.title).to eq "Noelia Hurtado & Carlitos Espinoza in Amsterdam 2014 #1"
      expect(metadata.description).to eq "24-26.10.2014 r., Amsterdam, Netherlands,\nPerformance 25th Oct, \"Salon de los Sabados\" in Academia de Tango"
      expect(metadata.upload_date).to eq "2014-10-26 15:21:29 UTC"
      expect(metadata.tags).to match_array [
        "Amsterdam",
        "Netherlands",
        "tango",
        "argentinian tango",
        "milonga",
        "noelia hurtado",
        "carlitos espinoza",
        "carlos espinoza",
        "espinoza",
        "hurtado",
        "noelia",
        "hurtado espinoza",
        "Salon de los Sabados",
        "Academia de Tango",
        "Nederland"
      ]
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
      expect(metadata.recommended_video_ids).to match_array(
        ["skypKrzXoMA",
          "Sn7vmyuvFbw",
          "SrZMf_yPI0M",
          "BXoJBry3DHE",
          "C17X0PZNJ8k",
          "q5HreDHJrcY",
          "e-7MNtkR2NM",
          "Nf1CEXsDyzQ",
          "arKaXhmrQsU",
          "mSJeJHq9u_8",
          "TP2sSyUYPnM",
          "k8g-QKho8kA",
          "5Nqnh4BqJMM",
          "nM3-_oHhJew",
          "enUAiJWv_0k",
          "tYxNt459ajk",
          "UhZO1dHv50o",
          "Xkc33HmERRw",
          "gWmP6KHCpJQ",
          "Ut1qvd-jPZk",
          "iLSem3UQbOE",
          "yzhSc21cToE",
          "Z8I6hxAVRdo",
          "p9C7DR1nEcA",
          "Kixb6ZH0xTY",
          "DA94Ava45no",
          "BCWA0ikpHQE",
          "_9qcVo9WP3A",
          "ER2Y2B6u5dw",
          "4RIrJJQypvw",
          "VWd6hY7YCVs",
          "_moxstakXMo",
          "lpVnEChF2xE",
          "1zFokyQkqyA",
          "GaLpdn1g_Hw",
          "CkynwNMS6tk",
          "HPUitIKEUFo",
          "ZDu72AKZYlg",
          "Mkjgu_V4EJU",
          "6YZCeyuu3dA",
          "rjRvjkCE3sw",
          "4HYwJWt3kC8",
          "eWp3xF7Eq7I",
          "XbSAp0gMnhs",
          "J2zyAS7ZCy0",
          "H8P-ACCz0o0",
          "YbQeG79MZFE",
          "GktEoSnDS9g",
          "nXT1RhZg8iE",
          "UW-Ofes7SkY",
          "XMccEHC4dIY",
          "qQwieW1Pr-E",
          "TC7KuyrJBnA",
          "n9VfBkru9h0",
          "s1DmyV4ugpQ",
          "1ZIZNL0RSvM",
          "e6gzOcamOfI",
          "JG1YPyQRl_I",
          "zmxKGnN8R60",
          "2YHmtXg7CdQ",
          "xTKzl1CntuA",
          "VCi6R9XnrQs",
          "PjCZp8UVMqw",
          "-d8TdnEoePA",
          "yO15YlSfdKQ",
          "CvVGVM3JUr8",
          "FaBAM1Q_HfQ",
          "b7DyuUZA8CI",
          "f7TIZxyZnAc",
          "ncE9r5QIP-g",
          "vyQwN0Am534",
          "Z8psWU2W9mI",
          "npINyOt57J4",
          "uWi1nd1ELyU",
          "DeXypKijsLs",
          "F6947SxgMEY",
          "dIjUHVNUku0",
          "u3dWVlb8fgA",
          "v3SSICMBJs0",
          "vNli-79MlHI",
          "NwfGgCtuMsg",
          "SDJPNRKBw3A",
          "osOLoOpjb0w",
          "W3wikk6mrEg",
          "7v_mSY00PzU",
          "STNC56yT6P0",
          "LU_Hjb5cTSU",
          "uoIkXfH50xw",
          "1OBMQCZ2yww",
          "2bIYd8GfIEg",
          "iINDpK4Y09Y",
          "zzpLRd8XuAw",
          "pxm0596FgkE",
          "TT2UGaLLGsk",
          "H5O7ezINPt0",
          "ZhtExMyRuL8",
          "I6bjs8WNiYs",
          "_KE2kSKSjjo",
          "l6pVVvQJuh8",
          "5R6fSdJM7so",
          "bQkd9DKhvg8",
          "wMJgUFYbO-s",
          "I5VGjPv8Lwo",
          "JV4nkFS15O8",
          "mbY0vApu2kY",
          "F2IUn2oOV_c",
          "-qNfcqAiyIo",
          "ATEerUsmcrU"]
      )
    end
  end
end
