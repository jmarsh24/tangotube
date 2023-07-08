class AddTrigramIndexToVideoTitles < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :normalized_title, :string
    add_index :videos, :normalized_title, using: :gin, opclass: {title: :gin_trgm_ops}
  end
end
