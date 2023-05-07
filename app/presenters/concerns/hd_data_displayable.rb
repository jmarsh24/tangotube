# frozen_string_literal: true

module HdDataDisplayable
  def hd_duration_data
    duration = metadata.youtube.duration
    return if duration.blank?

    hd_suffix = metadata.youtube.hd? ? "HD " : ""
    Time.at(duration).utc.strftime("#{hd_suffix}%M:%S")
  end
end
