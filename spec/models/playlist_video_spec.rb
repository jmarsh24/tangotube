# frozen_string_literal: true

# == Schema Information
#
# Table name: playlist_videos
#
#  id          :bigint           not null, primary key
#  playlist_id :bigint           not null
#  video_id    :bigint           not null
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe PlaylistVideo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
