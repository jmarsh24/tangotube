module ApplicationHelper
  include Turbo::StreamsHelper
  include Turbo::FramesHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'desc' ? 'asc' : 'desc'
    link_to "#{title} #{if css_class.present?
                          content_tag(:i, '', class: "fa fa-chevron-#{direction == 'asc' ? 'up' : 'down'}")
                        end}".html_safe,
            current_page_params.merge({ sort: column, direction: direction }), { class: css_class }
  end

  def current_page_params
    request.params.slice('orchestra',
                         'channel',
                         'leader',
                         'follower',
                         'genre',
                         'query',
                         'view_count',
                         'upload_date',
                         'popularity',
                         'song_id',
                         'event_id',
                         'hd',
                         'sort',
                         'direction')
  end

  def format_value(value)
    value ||= 'N/A'
  end
end
