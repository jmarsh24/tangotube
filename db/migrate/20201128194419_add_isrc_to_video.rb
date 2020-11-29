class AddIsrcToVideo < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :isrc, :string
  end
end
