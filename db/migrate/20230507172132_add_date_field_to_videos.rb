# frozen_string_literal: true

class AddDateFieldToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :new_date, :date
  end
end
