class Video::Filter
  attr_reader :video_relation, :filtering_params

  def initialize(video_relation, filtering_params: {}, current_user: nil)
    @video_relation = video_relation
    @filtering_params = filtering_params
  end

  def apply_filter
    filtering_params.each do |filter, value|
      next unless value.present? && video_relation.respond_to?(filter)

      @video_relation = if ["watched_by_user", "liked_by_user"].include?(filter)
        video_relation.send(filter, current_user)
      else
        video_relation.send(filter, value)
      end
    end

    video_relation
  end
end
