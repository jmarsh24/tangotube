# frozen_string_literal: true

class RemoveGenderAndRenameGenderNewInDancers < ActiveRecord::Migration[7.0]
  def up
    remove_column :dancers, :gender
    rename_column :dancers, :gender_new, :gender
  end

  def down
    add_column :dancers, :gender_new, :gender_new
    execute <<-SQL
      UPDATE dancers
      SET gender_new = CASE gender
        WHEN 'male' THEN 0
        WHEN 'female' THEN 1
      END
    SQL
    remove_column :dancers, :gender
    rename_column :dancers, :gender_new, :gender
  end
end
