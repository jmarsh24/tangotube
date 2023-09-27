# frozen_string_literal: true

class RemoveDuplicateIndexFromFeatures < ActiveRecord::Migration[7.0]
  def change
    remove_index :features, name: "index_features_on_featureable_type_and_featureable_id"
  end
end
