class Video::Sort
  attr_reader :video_relation, :sorting_params

  def initialize(video_relation, sorting_params: [{ column: "videos.popularity", direction: "desc" }])
    @video_relation = video_relation
    @sorting_params = sorting_params
  end

  def apply_sort
    return video_relation if sorting_params.blank?

    sorting_params.each do |criteria|
      video_relation = video_relation.order(criteria[:column] => criteria[:direction])
    end

    video_relation
  end
end
