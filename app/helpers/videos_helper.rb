module VideosHelper
  def formatted_view_count(view_count)
    number_to_human(view_count,
                    format:    "%n%u",
                    precision: 2,
                    units:     { thousand: "K",
                                 million:  "M",
                                 billion:  "B" })
  end

  def formatted_upload_date(upload_date)
    upload_date.strftime("%B %Y")
  end

  def link_to_query(external_song_attributes)
    link_to external_song_attributes,
            root_path(query: external_song_attributes.gsub(/\s-\s/, " ")),
            { 'data-turbo-frame': "_top" }
  end

  def link_to_song_id(song_attributes)
    link_to song_attributes,
            root_path(song_id: @video.song_id),
            { 'data-turbo-frame': "_top" }
  end

  def link_to_song(el_recodo_attributes, external_song_attributes)
    if el_recodo_attributes.present?
      link_to_song_id(el_recodo_attributes)
    elsif external_song_attributes.present?
      link_to_query(external_song_attributes)
    end
  end

  def link_to_primary_title(dancer_names, title, song_attributes, youtube_id)
    if dancer_names.present? && song_attributes.present?
      link_to dancer_names,
              root_path(v: youtube_id),
              { 'data-turbo-frame': "_top" }
    else
      link_to truncate(title, length: 85),
              root_path(v: youtube_id),
              { 'data-turbo-frame': "_top" }
    end
  end

  def formatted_metadata(video)
    "#{formatted_upload_date(video.upload_date)} • #{video.view_count} views • #{video.like_count} likes"
  end
end
