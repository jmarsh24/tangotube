class AddIndexToEvents < ActiveRecord::Migration[6.1]
  def change
    add_index(:events, :title)
  end
end
