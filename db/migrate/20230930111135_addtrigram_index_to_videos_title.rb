class AddtrigramIndexToVideosTitle < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :normalized_title, using: :gist, opclass: :gist_trgm_ops
    add_index :videos, :title, using: :gist, opclass: :gist_trgm_ops
  end
end
