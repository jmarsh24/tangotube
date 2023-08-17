class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true
      t.references :featureable, null: false, polymorphic: true
      t.timestamps
    end
    add_index :features, [:featureable_type, :featureable_id]
  end
end
