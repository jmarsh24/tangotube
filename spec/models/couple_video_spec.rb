# frozen_string_literal: true

# == Schema Information
#
# Table name: couple_videos
#
#  id         :bigint           not null, primary key
#  video_id   :bigint           not null
#  couple_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe CoupleVideo do
  pending "add some examples to (or delete) #{__FILE__}"
end
