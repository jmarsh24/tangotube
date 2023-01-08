# frozen_string_literal: true

desc "This task populates playlists"
task import_all_reviewed_playlists: :environment do
  puts "Adding all new playlists"
  Playlist.not_imported.reviewed.find_each do |channel|
    ImportPlaylistJob.perform_later(playlist.slug)
  end
  puts "done."
end

desc "This task updates channels"
task update_all_channels: :environment do
  Channel.where("total_videos_count < 500").where(active: true).find_each do |channel|
    ImportChannelJob.perform_later(channel.channel_id)
  end
  Channel.where("total_videos_count > 500").where(active: true).find_each do |channel|
    ImportChannelJob.perform_later(channel.channel_id)
  end
  puts "done."
end

desc "This task updates videos"
task update_all_videos: :environment do
  Video.not_hidden.find_each do |video|
    UpdateVideoJob.perform_later(video.youtube_id)
  end
  puts "done."
end

desc "This task updates videos"
task update_all_videos_missing_acr_response_code: :environment do
  Video.not_hidden.not_scanned_acrcloud.limit(10000).find_each do |video|
    UpdateVideoJob.perform_later(video.youtube_id)
  end
  puts "done."
end

desc "This task parses the performance date from the description and title"
task parse_all_performance_dates: :environment do
  puts "Parsing all missing performance dates"
  Video.where(performance_date: nil).find_each do |video|
    performance_date = Date.parse(video.description) || Date.parse(video.title)
    video.update(performance_date: performance_date)
  rescue Date::Error
  rescue RangeError
  end
  puts "done."
end

desc "Imports all youtube comments for existing videos"
task import_all_comments: :environment do
  Video.left_outer_joins(:yt_comments).order("updated_at asc").limit(10).limit(50000).find_each do |video|
    ImportCommentsJob.perform_later(video.youtube_id)
  end
end
