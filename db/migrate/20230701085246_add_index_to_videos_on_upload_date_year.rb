# frozen_string_literal: true

class AddIndexToVideosOnUploadDateYear < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :upload_date_year
  end
end
