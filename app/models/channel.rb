# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id            :bigint           not null, primary key
#  title         :string
#  channel_id    :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  thumbnail_url :string
#  reviewed      :boolean          default(FALSE)
#  active        :boolean          default(TRUE)
#  description   :text
#  metadata      :jsonb
#
class Channel < ApplicationRecord
  include Reviewable
  include Importable

  attribute :metadata, ChannelMetadata.to_type

  has_many :videos, dependent: :destroy
  has_many :performance_videos, through: :videos
  has_many :performances, through: :performance_videos
  has_many :dancers, through: :videos
  has_many :couples, through: :videos

  has_one_attached :thumbnail

  validates :channel_id, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
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
        thumbnail_url: channel.thumbnail_url
      )

      attach_avatar_thumbnail(channel.thumbnail_url)
    else
      destroy
    end
  rescue Yt::Errors::NoItems
    destroy
  end

  def import_new_videos(use_scraper: true, use_music_recognizer: true)
    return if !active?

    ChannelVideoFetcherJob.perform_later(channel_id, use_scraper:, use_music_recognizer:)
  end

  def update_videos(use_scraper: true, use_music_recognizer: true)
    return if !active?

    videos.find_each do |video|
      UpdateVideoJob.perform_later(video, use_scraper:, use_music_recognizer:)
    end
  end

  def fetch_and_save_metadata!
    ExternalChannelImporter.new.import(channel_id).tap do |metadata|
      update!(metadata:, imported_at: Time.current)
    end
  end

  def fetch_and_save_metadata_later!
    ImportChannelMetadataJob.perform_later(self)
  end

  private

  def attach_avatar_thumbnail(thumbnail_url)
    return if thumbnail_url.blank?

    thumbnail.attach(io: URI.parse(thumbnail_url).open, filename: "#{channel_id}.jpg")
  end
end
