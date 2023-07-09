# frozen_string_literal: true

class AddGenderToDancers < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      DO $$ BEGIN
        CREATE TYPE gender_new AS ENUM ('male', 'female');
      EXCEPTION
        WHEN duplicate_object THEN null;
      END $$;
    SQL

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
