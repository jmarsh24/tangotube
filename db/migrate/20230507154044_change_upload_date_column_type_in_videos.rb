# frozen_string_literal: true

class ChangeUploadDateColumnTypeInVideos < ActiveRecord::Migration[7.1]
  def up
    change_column :videos, :upload_date, :date
  end

  def down
    change_column :videos, :upload_date, :datetime
  end
end
