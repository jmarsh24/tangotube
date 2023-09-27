# frozen_string_literal: true

class AddForeignKeyConstraintsToCouples < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :couples, column: :dancer_id
    remove_foreign_key :couples, column: :partner_id

    add_foreign_key :couples, :dancers, column: :dancer_id, on_delete: :cascade
    add_foreign_key :couples, :dancers, column: :partner_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :couples, column: :dancer_id
    remove_foreign_key :couples, column: :partner_id

    add_foreign_key :couples, :dancers, column: :dancer_id
    add_foreign_key :couples, :dancers, column: :partner_id
  end
end
