class AddIndexToFeatured < ActiveRecord::Migration[7.0]
  def change
    add_index :features, [:user_id, :featureable_type, :featureable_id], unique: true, name: "index_features_on_user_and_featureable"
  end
end
