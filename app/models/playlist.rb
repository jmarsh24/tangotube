# frozen_string_literal: true

# == Schema Information
#
# Table name: playlists
#
#  id            :bigint           not null, primary key
#  slug          :string
#  title         :string
#  description   :string
#  channel_title :string
#  channel_id    :string
#  video_count   :string
#  imported      :boolean          default(FALSE)
#  videos_id     :bigint
#  user_id       :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  reviewed      :boolean          default(FALSE)
#
class Playlist < ApplicationRecord
  include Importable
  include Reviewable

  validates :slug, presence: true, uniqueness: true
end
