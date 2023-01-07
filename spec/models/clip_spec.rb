# == Schema Information
#
# Table name: clips
#
#  id            :bigint           not null, primary key
#  start_seconds :integer          not null
#  end_seconds   :integer          not null
#  title         :text
#  playback_rate :decimal(5, 3)    default(1.0)
#  user_id       :bigint           not null
#  video_id      :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  giphy_id      :string
#
require "rails_helper"

RSpec.describe Clip do
  pending "add some examples to (or delete) #{__FILE__}"
end
