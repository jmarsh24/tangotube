module ApplicationHelper
  include Turbo::StreamsHelper
  include Turbo::FramesHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"

    link_to "#{title} #{tag.i('', class: "fa fa-chevron-#{direction == 'asc' ? 'up' : 'down'}") if css_class.present?}".html_safe,
            current_page_params.merge({ sort: column, direction: direction }), { class: css_class }
  end

  def current_page_params
    request.params.slice("channel_id",
                         "leader_id",
                         "follower_id",
                         "song_id",
                         "event_id",
                         "year",
                         "genre",
                         "orchestra",
                         "query",
                         "view_count",
                         "upload_date",
                         "popularity",
                         "hd")
  end
end
