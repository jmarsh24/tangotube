# frozen_string_literal: true

# == Schema Information
#
# Table name: watches
#
#  id         :uuid             not null, primary key
#  user_id    :bigint           not null
#  video_id   :bigint           not null
#  watched_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Watch < ApplicationRecord
  belongs_to :user
  belongs_to :video
end
