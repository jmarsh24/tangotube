class AddNicknameToLeader < ActiveRecord::Migration[6.0]
  def change
    add_column :leaders, :nickname, :string
  end
end
