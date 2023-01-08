# frozen_string_literal: true

class ChangePlaybackRateColumnInClips < ActiveRecord::Migration[7.0]
  def up
    change_column :clips, :playback_rate, :decimal, precision: 5, scale: 3, default: 1.0
  end

  def down
    change_column :clips, :playback_rate, :float
  end
end
