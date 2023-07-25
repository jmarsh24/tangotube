# frozen_string_literal: true

# == Schema Information
#
# Table name: video_searches
#
#  video_id       :bigint
#  youtube_id     :string
#  upload_date    :date
#  dancer_names   :text
#  channel_title  :text
#  song_title     :text
#  song_artist    :text
#  orchestra_name :text
#  event_city     :text
#  event_title    :text
#  event_country  :text
#  video_title    :text
#  score          :float
#
RSpec.describe VideoSearch do
  fixtures :all

  describe "#search" do
    it "finds results" do
      videos = [videos(:video_1_featured), videos(:video_4_featured)]

      expect(VideoSearch.search("carlitos espinoza")).to eq []

      VideoSearch.refresh

      results = VideoSearch.search("carlitos espinoza")
      expect(results).to match_array(videos.map(&:id))
    end
  end
end
