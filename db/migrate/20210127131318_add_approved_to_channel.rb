class AddApprovedToChannel < ActiveRecord::Migration[6.1]
  def change
    add_column :channels, :reviewed, :boolean
  end
end
