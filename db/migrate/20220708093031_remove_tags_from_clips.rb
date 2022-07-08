class RemoveTagsFromClips < ActiveRecord::Migration[7.0]
  def change
    remove_column :clips, :tags
  end
end
