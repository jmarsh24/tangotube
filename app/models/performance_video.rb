class PerformanceVideo < ApplicationRecord
  belongs_to :video
  belongs_to :performance

  counter_culture :performance, column_name: "videos_count"
end
