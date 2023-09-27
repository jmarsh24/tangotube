# frozen_string_literal: true

class ModifyForeignKeyForCascadeDelete < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :couple_videos, :couples

    add_foreign_key :couple_videos, :couples, on_delete: :cascade
  end

  def down
    remove_foreign_key :couple_videos, :couples

    add_foreign_key :couple_videos, :couples
  end
end
