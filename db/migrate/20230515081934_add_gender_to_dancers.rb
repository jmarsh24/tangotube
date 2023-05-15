class AddGenderToDancers < ActiveRecord::Migration[7.1]
  def up
    create_enum "gender_new", ["male", "female"]
    add_column :dancers, :gender_new, :gender_new

    # Map old integer values to new enum values in a single SQL statement
    execute <<-SQL
      UPDATE dancers SET gender_new = CASE gender
        WHEN 0 THEN 'male'
        WHEN 1 THEN 'female'
      END
    SQL

    remove_column :dancers, :gender
    rename_column :dancers, :gender_new, :gender
  end

  def down
    add_column :dancers, :gender_new, :integer

    execute <<-SQL
      UPDATE dancers SET gender_new = CASE gender
        WHEN 'male' THEN 0
        WHEN 'female' THEN 1
      END
    SQL

    remove_column :dancers, :gender
    rename_column :dancers, :gender_new, :gender
    drop_enum "gender_new"
  end
end
