class AddTextToVideos < ActiveRecord::Migration[7.0]
  def change
    enable_extension :pg_trgm

    add_column :videos, :index, :text
    add_index :videos, :index, opclass: {index: :gin_trgm_ops}, using: :gin
  end
end
