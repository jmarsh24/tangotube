# frozen_string_literal: true

module TitleLinkable
  def title_link
    if dancers.present?
      link_to dancer_names, watch_path(v: youtube_id)
    else
      link_to metadata.youtube.title, watch_path(v: youtube_id)
    end
  end

  private

  def dancer_names
    @dancer_names ||= dancers.map(&:full_name).join(" & ")
  end
end
