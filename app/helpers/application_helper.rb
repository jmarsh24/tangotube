module ApplicationHelper
  include Turbo::StreamsHelper
  include Turbo::FramesHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    link_to "#{title} #{tag.i('', class: "fa fa-chevron-#{direction == 'asc' ? 'up' : 'down'}") if css_class.present?}",
            current_page_params.merge({ sort: column, direction: direction }),
            { class: css_class }
  end

  def current_page_params
    request.params.slice(sortable_params)
  end

  def sortable_params
    %w[orchestra channel leader follower genre view_count upload_date popularity song_id event_id hd sort direction]
  end
end
