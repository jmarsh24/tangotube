class AddNormalizedNameToLeader < ActiveRecord::Migration[6.1]
  def change
    add_column :leaders, :normalized_name, :string
  end
end
