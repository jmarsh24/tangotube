desc "This task populates playlists"
task import_all_reviewed_playlists: :environment do
  puts "Adding all new playlists"
  Playlist.not_imported.reviewed.find_each do |channel|
    ImportPlaylistWorker.perform_async(playlist.slug)
  end
  puts "done."
end

desc "This task updates channels"
task update_all_channels: :environment do
  Channel.where('total_videos_count < 500').find_each do |channel|
    ImportChannelWorker.perform_async(channel.channel_id)
  end
  Channel.where('total_videos_count > 500').find_each do |channel|
    ImportChannelWorker.perform_async(channel.channel_id)
  end
  puts "done."
end

desc "This task updates videos"
task update_all_videos: :environment do
  if Time.now.monday?
    Video.all.order('updated_at ASC').limit(100000).find_each do |video|
      ImportVideoWorker.perform_async(video.youtube_id)
    end
    puts "done."
  end
end

desc "This task parses the performance date from the description and title"
task parse_all_performance_dates: :environment do
  puts "Parsing all missing performance dates"
  Video.where(performance_date: nil).find_each do |video|
    performance_date = Date.parse(video.description) ||Date.parse(video.title)
    video.update(performance_date: performance_date)
    rescue Date::Error
    rescue RangeError
  end
  puts "done."
end

namespace :refreshers do
  desc "Refresh materialized view for Videos"
  task videos_searches: :environment do
    VideosSearch.refresh
  end
end

namespace :export do
  desc "Export videos"
  task :videos_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Video.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end
    File.open(Rails.root.join("seed", "data", "videos.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export leaders"
  task :leader_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Leader.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end

    File.open(Rails.root.join("seed", "data", "leader.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export followers"
  task :follower_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Follower.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end

    File.open(Rails.root.join("seed", "data", "follower.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export songs"
  task :song_to_seeds => :environment do
      FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Song.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end

    File.open(Rails.root.join("seed", "data", "song.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export events"
  task :event_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Event.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end

    File.open(Rails.root.join("seed", "data", "event.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export channels"
  task :channel_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Channel.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end

    File.open(Rails.root.join("seed", "data", "channel.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export playlists"
  task :playlist_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join("seed", "data"))
    data = Playlist.all.map do |e|
      e.attributes.except("created_at", "updated_at", "id")
    end

    File.open(Rails.root.join("seed", "data", "playlist.yml"), "w+") do |f|
      f.puts(YAML.dump(data))
    end
  end
end
