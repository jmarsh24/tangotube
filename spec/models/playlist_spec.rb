# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  slug          :string
#  title         :string
#  description   :string
#  channel_title :string
#  channel_id    :string
#  video_count   :string
#  imported      :boolean          default(FALSE)
#  videos_id     :bigint
#  user_id       :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "rails_helper"

RSpec.describe Playlist, type: :model do
  it_behaves_like "an importable", :playlist

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
