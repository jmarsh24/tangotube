# frozen_string_literal: true

class SearchBoxComponent < ViewComponent::Base
  def initialize(form_url:, total_videos_count:, query_params: {})
    @form_url = form_url
    @total_videos_count = total_videos_count
    @query_params = query_params
  end
end
