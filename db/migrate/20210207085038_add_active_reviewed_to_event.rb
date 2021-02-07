class AddActiveReviewedToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :active, :boolean, default: true
    add_column :events, :reviewed, :boolean, default: false
  end
end
