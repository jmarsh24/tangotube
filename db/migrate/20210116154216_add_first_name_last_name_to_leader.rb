class AddFirstNameLastNameToLeader < ActiveRecord::Migration[6.1]
  def change
    add_column :leaders, :first_name, :string
    add_column :leaders, :last_name, :string
  end
end
