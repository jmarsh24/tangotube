# frozen_string_literal: true

module ComponentHelper
  def paginated(scope, partial: nil, frame_id: "pagination-frame", **options)
    turbo_frame_tag(frame_id, target: "_top", **options) do
      render "components/pagination", items: scope, partial:, frame_id:
    end
  end
end
