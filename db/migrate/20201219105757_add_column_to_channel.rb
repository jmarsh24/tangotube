class AddColumnToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :thumbnail_url, :string
  end
end
