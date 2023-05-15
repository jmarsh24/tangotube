# frozen_string_literal: true

class AddGenderToDancers < ActiveRecord::Migration[7.1]
  def up
    create_enum "gender_new", ["male", "female"]
    add_column :dancers, :gender_new, :gender_new
    execute <<-SQL
      UPDATE dancers
      SET gender_new = CASE gender
        WHEN 0 THEN 'male'::gender_new
        WHEN 1 THEN 'female'::gender_new
      END
    SQL
  end

  def down
    remove_column :dancers, :gender_new
  end
end
