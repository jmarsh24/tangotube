class VideoPresenter < SimpleDelegator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::NumberHelper

  def title_link
    if dancers.present?
      link_to dancer_names, watch_path(v: youtube_id)
    else
      link_to metadata.title, watch_path(v: youtube_id)
    end
  end

  def song_link
    if song.present?
      link_to song.full_title, root_path(song: song.slug)
    elsif song_string.present?
      link_to song_string, root_path(query: song_query_param)
    end
  end

  def meta_title
    dancers.present? ? dancer_names : metadata.title
  end

  def meta_description
    song&.full_title || song_string
  end

  def display_metadata
    like_count = number_with_delimiter(metadata.youtube.like_count)
    upload_date = format_date(metadata.youtube.upload_date)
    views = number_with_delimiter(metadata.youtube.view_count)
    "#{upload_date} • #{views} views • #{like_count} likes"
  end

  def hd_duration_data
    return if metadata.youtube.duration.blank?

    if metadata.youtube.hd?
      "HD #{Time.at(metadata&.youtube&.duration).utc.strftime("%M:%S")}"
    else
      Time.at(metadata&.youtube&.duration).utc.strftime("%M:%S")
    end
  end

  def performance_number
    if performance.present?
      "#{performance_video.position} / #{performance.videos_count}"
    end
  end

  private

  def format_date(performance_date)
    performance_date&.strftime("%B %Y")
  end

  def dancer_names
    @dancer_names ||= dancers.map(&:full_name).join(" & ")
  end

  def song_string
    @song_string ||= begin
      song = metadata.youtube.song
      title = song.titles.first
      artist = titleize_artist_name(song.artist)
      format_song_attributes(title, artist)
    end
  end

  def song_query_param
    song_string.gsub(/\s-\s/, " ")
  end

  def format_song_attributes(title, artist, genre = nil)
    formatted_title = title&.titleize
    formatted_artist = titleize_artist_name(artist)
    genre.present? ? "#{formatted_title} - #{formatted_artist} - #{genre.titleize}" : "#{formatted_title} - #{formatted_artist}"
  end

  def titleize_artist_name(artist_name)
    artist_name&.split("'")&.map(&:titleize)&.join("'")
  end
end
