# frozen_string_literal: true

require "rails_helper"

RSpec.describe Import::Youtube::Scraper do
  fixtures :all
  let(:slug) { videos(:video_1_featured).youtube_id }

  describe "video_metadata" do
    it "returns the video metadata from youtube" do
      youtube_scraper = Import::Youtube::Scraper.new
      allow(youtube_scraper).to receive(:retrieve_html).and_return(File.read("spec/fixtures/files/youtube_video.html"))

      metadata = youtube_scraper.data(slug)

      expect(metadata.song.titles).to include "Cuando El Amor Muere"
      expect(metadata.song.artist).to eq "Carlos Di Sarli y su Orquesta Típica"
      expect(metadata.recommended_video_ids).to match_array ["MQ96oN4AnKw", "fN4ThtBSiU8", "LTptQYCisJk", "m8-A40Ka-6o", "cN34evcqEs0", "xzucEZx6c_E", "6cZR3kIpCu8", "BLMr09iTLjQ", "3O33gHJGibQ", "NA-muRg2jyk", "l4gmmR6BGY4", "bnIG3wVZ52Q", "vVz4dqCc2lc", "yHIcLs4U7ws", "rX7CsSnqAp4", "FnPa-M9Ezos", "zhRC1KsvQRE", "H2Q9jFGNC94", "BLtBiAXVsaM", "Eu6FknOsobQ", "w_GxmSMfyvE", "tVmD4x0NtsE", "1Gd1tHNdOjI", "kUnnJX79HBI", "3SVER-bHVgU", "XMzG-wZlkfs", "QbYu0GQSD7s", "fOYQ4dvW1vA", "_7mHTtKKvtw", "GqiLQ3VMwYo", "iOieQi7iYwA", "cythVHoNxbA", "IPb60Xi8TG0", "8wCNgAJE7Hs", "oMXN3sWVEvg", "WzgVEKe0e-I", "qSToBgeNilw", "3ZJsUlpabk8", "haB_VZX-dFY", "FfPJ1Db2WW8", "U2Sc2UQmyq0", "KOnjYgmiACQ", "bT-grjvr_-E", "7DvJ982ePjQ", "M3CJS8Urojs", "eLZ-qxhOB5o", "KlyEvwhJqQQ", "0ZPR_DNTghE", "eJV_BndWD9U", "SoeK7Pw4ESQ", "aZ-h6nKMAaw", "DHSk6_mnRIs", "6OEO-9xEHtw", "Su4DEi4VpMQ", "ahnzHMufnTE", "nhBkMugKLkI", "uy_3J99ELp4", "Vzv_FDh4N2o", "acb9It00Pio", "RpEimFXYqTs", "NNPnLBPt39g", "h1CVn_vozzk", "I8Ow_1eg8fg", "mUJ-U9KA970", "LIw7BYz1nkU", "bEzw8JMambs", "Csz5HsEZSDI", "b7jJ8EjGW-M", "k2IvpmF8jLs", "WGR6H1W-jsQ"]
    end
  end
end
