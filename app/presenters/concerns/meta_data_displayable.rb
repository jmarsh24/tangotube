# frozen_string_literal: true

module MetaDataDisplayable
  def display_metadata
    formatted_like_count = formatted_count(metadata.youtube.like_count)
    formatted_view_count = formatted_count(metadata.youtube.view_count)
    "#{formatted_performance_date} • #{formatted_view_count} views • #{formatted_like_count} likes"
  end

  def meta_title
    dancers.present? ? dancer_names : metadata.title
  end

  def meta_description
    song&.full_title || song_string
  end

  private

  def formatted_count(count)
    number_to_human(
      count,
      format: "%n%u",
      precision: 2,
      units: {
        thousand: "K",
        million: "M",
        billion: "B"
      }
    )
  end

  def formatted_performance_date
    metadata.youtube.upload_date.strftime("%B %Y")
  end
end
