class AddIndexToVideoPerformanceDate < ActiveRecord::Migration[6.1]
  def change
    add_index(:videos, :performance_date)
  end
end
