
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
