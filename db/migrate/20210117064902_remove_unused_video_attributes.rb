class RemoveUnusedVideoAttributes < ActiveRecord::Migration[6.1]
  def change
    remove_column :videos, :avg_rating
    remove_column :videos, :performance_date
    remove_column :videos, :performance_number
    remove_column :videos, :performance_total
    remove_column :videos, :videotype_id
    remove_column :videos, :confidence_score
    remove_column :videos, :event_id
    remove_column :videos, :length
  end
end
