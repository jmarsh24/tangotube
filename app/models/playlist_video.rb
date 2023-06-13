# frozen_string_literal: true

class PlaylistVideo < ApplicationRecord
  belongs_to :playlist
  belongs_to :video
end
