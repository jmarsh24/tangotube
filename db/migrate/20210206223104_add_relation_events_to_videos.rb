class AddRelationEventsToVideos < ActiveRecord::Migration[6.1]
  def change
    add_reference :videos, :event, foreign_key: true
  end
end
