class AddIndexToAcrResponseCodeOnVideos < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :acr_response_code
  end
end
