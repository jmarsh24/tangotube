class RemoveDateTimeFromVideo < ActiveRecord::Migration[7.1]
  def change
    remove_column :videos, :upload_date
    rename_column :videos, :new_date, :upload_date
  end
end
