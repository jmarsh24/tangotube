class AddNameTrigramIndexToDancers < ActiveRecord::Migration[7.0]
  def change
    add_index :dancers, :name, using: :gist, opclass: :gist_trgm_ops
  end
end
