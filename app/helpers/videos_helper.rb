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

  def link_to_song_id(song_attributes, video)
    link_to song_attributes,
            root_path(song_id: video.song_id),
            { 'data-turbo-frame': "_top" }
  end

  def link_to_song(el_recodo_attributes, external_song_attributes, video)
    if el_recodo_attributes.present?
      link_to_song_id(el_recodo_attributes, video)
    elsif external_song_attributes.present?
      link_to_query(external_song_attributes)
    end
  end

  def link_to_primary_title(dancer_names, title, song_attributes, youtube_id)
    if dancer_names.present? && song_attributes.present?
      link_to dancer_names,
              watch_path(v: youtube_id),
              { 'data-turbo-frame': "_top" }
    else
      link_to truncate(title, length: 85),
              watch_path(v: youtube_id),
              { 'data-turbo-frame': "_top" }
    end
  end

  def formatted_metadata(video)
    "#{formatted_upload_date(video.upload_date)} • #{video.view_count} views • #{video.like_count} likes"
  end

  def hd_duration_data(video)
    if video.hd?
      "HD #{Time.at(video.duration).utc.strftime('%M:%S')}"
    else
      Time.at(video.duration).utc.strftime("%M:%S")
    end
  end

  def channel_title(video)
    truncate(video.channel.title, length: 45, omission: "")
  end
end
