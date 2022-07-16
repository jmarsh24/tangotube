class DancerVideo < ApplicationRecord
  belongs_to :dancer
  belongs_to :video
  counter_culture :dancer, column_name: "videos_count"

  enum role: { neither: 0, leader: 1, follower: 2, both: 3 }
end
