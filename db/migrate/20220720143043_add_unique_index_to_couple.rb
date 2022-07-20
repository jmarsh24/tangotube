class AddUniqueIndexToCouple < ActiveRecord::Migration[7.0]
  def change
    add_index :couples, [:dancer_id, :partner_id], unique: true
  end
end
