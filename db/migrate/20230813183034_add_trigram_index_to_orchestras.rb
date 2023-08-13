class AddTrigramIndexToOrchestras < ActiveRecord::Migration[7.0]
  def change
    remove_index :orchestras, :name
    add_index :orchestras, :name, using: :gist, opclass: {name: :gist_trgm_ops}
  end
end
