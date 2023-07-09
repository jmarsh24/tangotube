# frozen_string_literal: true

class Video::Filter
  attr_reader :video_relation, :filtering_params
  attr_accessor :user

  def initialize(video_relation, filtering_params: {}, excluded_youtube_id: nil, user: nil)
    @video_relation = video_relation
    @video_relation = @video_relation.exclude_youtube_id(excluded_youtube_id) if excluded_youtube_id.present?
    @filtering_params = filtering_params
    @user = user
  end

  def filtered_videos
    filtering_params.each do |filter, value|
      filter = filter.to_sym if filter.is_a?(String)

      next unless value.present? && video_relation.respond_to?(filter)

      @video_relation = if [:watched, :liked].include?(filter)
        video_relation.public_send(filter, user)
      else
        video_relation.public_send(filter, value)
      end
    end

    video_relation
  end

  def videos
    apply_filter
  end
end
