class AddFirstNameLastNameToFollower < ActiveRecord::Migration[6.1]
  def change
    add_column :followers, :first_name, :string
    add_column :followers, :last_name, :string
  end
end
