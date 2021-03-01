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
  pending "add some examples to (or delete) #{__FILE__}"
end
