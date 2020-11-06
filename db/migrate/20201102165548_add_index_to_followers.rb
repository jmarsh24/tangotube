class AddIndexToFollowers < ActiveRecord::Migration[6.0]
  def change
    add_index(:followers, :name)
  end
end
