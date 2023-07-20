# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id                  :bigint           not null, primary key
#  title               :string
#  channel_id          :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  thumbnail_url       :string
#  reviewed            :boolean          default(FALSE)
#  active              :boolean          default(TRUE)
#  description         :text
#  metadata            :jsonb
#  metadata_updated_at :datetime
#  videos_count        :integer          default(0)
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
  scope :inactive, -> { where(active: false) }
  scope :search, ->(query) {
    normalized_query = TextNormalizer.normalize(query)
    quoted_query = ActiveRecord::Base.connection.quote_string(normalized_query)
    select("*, (videos_count/1000 * .2 * similarity(title, '#{quoted_query}')) as score")
      .where("? % title", normalized_query)
      .order("score DESC")
  }
  scope :most_popular, -> { order(videos_count: :desc) }

  def import_new_videos(use_scraper: false, use_music_recognizer: false)
    return nil unless active && metadata.present?

    new_video_ids = videos.map(&:youtube_id) - metadata.video_ids

    new_video_ids.each do |video_id|
      ImportVideoJob.perform_later(video_id, use_scraper:, use_music_recognizer:)
    end
  end

  def update_videos(use_scraper: false, use_music_recognizer: false)
    return unless active

    videos.find_each do |video|
      UpdateVideoJob.perform_later(video, use_scraper:, use_music_recognizer:)
    end
  end

  def fetch_and_save_metadata!
    metadata = ExternalChannelImporter.new.fetch_metadata(channel_id)
    update!(metadata:, metadata_updated_at: Time.current)
  rescue Yt::Errors::NoItems
    destroy!
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
