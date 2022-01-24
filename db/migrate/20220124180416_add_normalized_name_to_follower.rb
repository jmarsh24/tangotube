class AddNormalizedNameToFollower < ActiveRecord::Migration[6.1]
  def change
    add_column :followers, :normalized_name, :string
  end
end
