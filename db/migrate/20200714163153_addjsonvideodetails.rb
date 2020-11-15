class Addjsonvideodetails < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :description, :string
    add_column :videos, :channel, :string
    add_column :videos, :channel_id, :string
    add_column :videos, :duration, :integer
    add_column :videos, :upload_date, :date
    add_column :videos, :view_count, :integer
    add_column :videos, :avg_rating, :integer
    add_column :videos, :tags, :string
  end
end
