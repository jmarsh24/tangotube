class ModifyVideosCountToPerformances < ActiveRecord::Migration[7.0]
  def change
    change_column :performances, :videos_count, :integer, default: 0, null: false
  end
end
