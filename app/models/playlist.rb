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
#
class Playlist < ApplicationRecord
  validates :slug, presence: true, uniqueness: true

  has_many :videos

  scope :imported,     ->   { where(imported: true) }
  scope :not_imported, ->   { where(imported: false) }
  scope :reviewed,     ->   { where(reviewed: true) }
  scope :not_reviewed, ->   { where(reviewed: false) }
end
