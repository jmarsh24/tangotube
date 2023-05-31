class Video::Filter
  attr_reader :video_relation, :filtering_params, :current_user

  def initialize(video_relation, filtering_params: {}, current_user: nil)
    @video_relation = video_relation
    @filtering_params = filtering_params
    @current_user = current_user
  end

  def apply_filter
    filtering_params.each do |filter, value|
      next unless value.present? && video_relation.respond_to?(filter)

      @video_relation = video_relation.send(filter, value)
    end

    video_relation
  end
end
