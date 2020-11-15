class AddVideoTypeEventPerformancedatePerformancenumber < ActiveRecord::Migration[6.0]
  def up
    add_column :videos, :youtube_song, :string
    add_column :videos, :youtube_artist, :string
    add_column :videos, :performance_date, :datetime
    add_column :videos, :performance_number, :int
    add_column :videos, :performance_total, :int
  end

  def down
    remove_column :videos, :youtube_song, :string
    remove_column :videos, :youtube_artist, :string
    remove_column :videos, :performance_date, :datetime
    remove_column :videos, :performance_number, :int
    remove_column :videos, :performance_total, :int
  end
end
