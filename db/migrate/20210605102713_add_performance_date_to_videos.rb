class AddPerformanceDateToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :performance_date, :datetime
  end
end
