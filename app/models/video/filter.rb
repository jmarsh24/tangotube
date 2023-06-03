class Video::Filter
  attr_reader :video_relation, :filtering_params
  attr_accessor :current_user

  def initialize(video_relation, filtering_params: {}, excluded_youtube_id: nil, current_user: nil)
    @video_relation = video_relation
    @video_relation = @video_relation.exclude_youtube_id(excluded_youtube_id) if excluded_youtube_id.present?
    @filtering_params = filtering_params
    @current_user = current_user
  end

  def apply_filter
    filtering_params.each do |filter, value|
      filter = filter.to_sym if filter.is_a?(String)

      next unless value.present? && video_relation.respond_to?(filter)

      @video_relation = if [:watched, :liked].include?(filter)
        video_relation.send(filter, current_user)
      else
        video_relation.send(filter, value)
      end
    end

    video_relation
  end

  def videos
    apply_filter
  end
end
