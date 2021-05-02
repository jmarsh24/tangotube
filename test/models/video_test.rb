# == Schema Information
#
# Table name: videos
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :text
#  youtube_id         :string
#  leader_id          :bigint
#  follower_id        :bigint
#  description        :string
#  channel            :string
#  channel_id         :string
#  duration           :integer
#  upload_date        :date
#  view_count         :integer
#  avg_rating         :integer
#  tags               :string
#  song_id            :bigint
#  youtube_song       :string
#  youtube_artist     :string
#  performance_date   :datetime
#  performance_number :integer
#  performance_total  :integer
#  videotype_id       :bigint
#  event_id           :bigint
#

require "test_helper"

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
