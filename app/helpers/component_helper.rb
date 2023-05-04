# frozen_string_literal: true

module ComponentHelper
  def paginated(scope, partial: nil, **options)
    turbo_frame_tag("pagination-frame", target: "_top", **options) do
      render "components/pagination", items: scope, partial:
    end
  end
end
