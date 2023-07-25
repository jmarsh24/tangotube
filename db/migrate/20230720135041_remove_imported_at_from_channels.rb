# frozen_string_literal: true

class RemoveImportedAtFromChannels < ActiveRecord::Migration[7.0]
  def change
    remove_column :channels, :imported_at, :datetime
  end
end
