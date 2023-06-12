# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id                    :bigint           not null, primary key
#  title                 :string
#  channel_id            :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  thumbnail_url         :string
#  imported              :boolean          default(FALSE)
#  imported_videos_count :integer          default(0)
#  total_videos_count    :integer          default(0)
#  yt_api_pull_count     :integer          default(0)
#  reviewed              :boolean          default(FALSE)
#  videos_count          :integer          default(0), not null
#  active                :boolean          default(TRUE)
#  description           :text
#
class Channel < ApplicationRecord
  include Reviewable
  include Importable

  has_many :videos, dependent: :destroy
  has_many :performance_videos, through: :videos
  has_many :performances, through: :performance_videos
  has_many :dancers, through: :videos
  has_many :couples, through: :videos

  has_one_attached :thumbnail

  validates :channel_id, presence: true, uniqueness: true

  scope :title_search,
    lambda { |query|
      where("unaccent(title) ILIKE unaccent(?)", "%#{query}%")
    }

  def update_from_youtube!
    channel = Yt::Channel.new(id: channel_id) || nil

    if channel.present?
      update!(
        title: channel.title,
        description: channel.description,
        thumbnail_url: channel.thumbnail_url,
        videos_count: channel.video_count
      )

      attach_avatar_thumbnail(channel.thumbnail_url)
    else
      destroy
    end
  rescue Yt::Errors::NoItems
    destroy
  end

  def import_videos
    return if inactive?

    if videos.empty?
      ExternalVideoImporter::Importer.new.import(channel_id)
    else
      videos.each do |video|
        next if video.exist?

        ExternalVideoImporter::Importer.new.import(channel_id)
        break
      end
    end
  end

  private

  def attach_avatar_thumbnail(thumbnail_url)
    return if thumbnail_url.blank?

    thumbnail.attach(io: URI.parse(thumbnail_url).open, filename: "#{channel_id}.jpg")
  end
end
