class Video::Sort
  attr_reader :video_relation, :sorting_params

  def initialize(video_relation, sorting_params: {column: "videos.popularity", direction: "desc"})
    @video_relation = video_relation
    @sorting_params = sorting_params
  end

  def apply_sort
    return video_relation if sorting_params.blank?

    video_relation.order(sorting_params[:column] => sorting_params[:direction])
  end
end
