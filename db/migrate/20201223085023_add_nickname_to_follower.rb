class AddNicknameToFollower < ActiveRecord::Migration[6.0]
  def change
    add_column :followers, :nickname, :string
  end
end
