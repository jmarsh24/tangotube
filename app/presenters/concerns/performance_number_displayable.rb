# frozen_string_literal: true

module PerformanceNumberDisplayable
  def performance_number
    if performance.present?
      "#{performance_video.position} / #{performance.videos_count}"
    end
  end
end
