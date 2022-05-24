class AddActiveToChannel < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :active, :boolean, default: :true
  end
end
