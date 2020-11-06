class AddIndexToLeaders < ActiveRecord::Migration[6.0]
  def change
    add_index(:leaders, :name)
  end
end
