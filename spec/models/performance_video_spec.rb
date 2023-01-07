# == Schema Information
#
# Table name: performance_videos
#
#  id             :bigint           not null, primary key
#  video_id       :bigint
#  performance_id :bigint
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe PerformanceVideo do
  pending "add some examples to (or delete) #{__FILE__}"
end
