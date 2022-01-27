class AddPerformanceInfoToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :performance_number, :integer
    add_column :videos, :performance_total_number, :integer
  end
end
