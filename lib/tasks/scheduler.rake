desc 'This task populates videos'
task import_all_reviewed_channels: :environment do
  puts 'Populating videos from channels'
  Channel.not_imported.reviewed.find_each do |channel|
    Video::YoutubeImport.from_channel(channel.channel_id)
  end
  puts 'done.'
end

desc 'This task populates playlists'
task import_all_reviewed_playlists: :environment do
  puts 'Adding all new playlists'
  Playlist.not_imported.reviewed.find_each do |channel|
    Video::YoutubeImport.from_playlist(playlist.slug)
  end
  puts 'done.'
end

desc 'This task updates channels'
task update_all_channels: :environment do
  puts 'Updating All Channels'
  Channel.imported.reviewed.find_each do |channel|
    Video::YoutubeImport::Channel.import(channel.channel_id)
  end

  Channel.not_imported.reviewed.find_each do |channel|
    Video::YoutubeImport::Channel.import_videos(channel.channel_id)
  end
  puts 'done.'
end

# For every active song and in order of popularity search
# for videos that have both the song title and last name
# of the orchestra somewhere in the attributes

desc 'This task matches all the songs in the database'
task match_all_songs: :environment do
  puts 'Matching songs'
  Song.filter_by_active.sort_by_popularity.find_each do |song|
    videos = Video.missing_song
                  .with_song_title(song.title)
                  .with_song_artist_keyword(song.last_name_search)
    next if videos.empty?

    videos.update_all(song_id: song.id)
  end
  puts 'done.'
end

desc 'This task looks for string matches in video title for leaders'
task match_all_leaders: :environment do
  puts 'Matching leaders'
  Leader.all.find_each do |leader|
    videos = Video.title_match_missing_leader(leader.name) if leader.name.present?
    videos = videos.or(Video.title_match_missing_leader(leader.abrev_name)) if leader.abrev_name.present?
    videos = videos.or(Video.title_match_missing_leader(leader.abrev_name_nospace)) if leader.abrev_name_nospace.present?
    videos = videos.or(Video.title_match_missing_leader(leader.nickname)) if leader.nickname.present?

    next if videos.empty?

    videos.update_all(leader_id: leader.id)
  end
  puts 'done.'
end

desc 'This task looks for string matches in video title for followers'
task match_all_followers: :environment do
  puts 'Matching followers'
  Follower.all.find_each do |follower|
    videos = Video.title_match_missing_follower(follower.name) if follower.name.present?
    videos = videos.or(Video.title_match_missing_follower(follower.abrev_name)) if follower.abrev_name.present?
    videos = videos.or(Video.title_match_missing_follower(follower.abrev_name_nospace)) if follower.abrev_name_nospace.present?
    videos = videos.or(Video.title_match_missing_follower(follower.nickname)) if follower.nickname.present?

    next if videos.empty?

    videos.update_all(follower_id: follower.id)
  end
  puts 'done.'
end

# All videos where the response code is not successfully identified,
# send a request to acrcloud to search for a match
desc 'This task performs all music matches from acrcloud'
task match_all_unscanned_unrecognized_videos: :environment do
  puts 'Fetching all missing music matches with ACR Cloud'
  Video.unscanned_acrcloud.find_each do |video|
    AcrMusicMatchWorker.perform_async(video.youtube_id)
end
  puts 'done.'
end

# For every video where we haven't checked
# to see if youtube has a music match
# Create a import youtube worker which will
# check if youtube has identified the music contained in the video.
desc 'This task fetches music data which exists on youtube'
task fetch_all_youtube_matches: :environment do
  puts 'Fetching all missing youtube matches'
  Video.unscanned_youtube_music.find_each do |video|
    YoutubeMusicMatchWorker.perform_async(video.youtube_id)
  end
  puts 'done.'
end

desc 'This task populates videos'
task update_imported_video_counts: :environment do
  puts 'Updating imported video counts'
  Video.update_imported_video_counts
  puts 'done.'
end

namespace :refreshers do
  desc 'Refresh materialized view for Videos'
  task videos_searches: :environment do
    VideosSearch.refresh
  end
end

namespace :export do
  desc "Export videos"
  task :videos_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Video.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end
    File.open(Rails.root.join('seed', 'data', 'videos.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export leaders"
  task :leader_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Leader.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end

    File.open(Rails.root.join('seed', 'data', 'leader.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export followers"
  task :follower_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Follower.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end

    File.open(Rails.root.join('seed', 'data', 'follower.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export songs"
  task :song_to_seeds => :environment do
      FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Song.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end

    File.open(Rails.root.join('seed', 'data', 'song.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export events"
  task :event_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Event.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end

    File.open(Rails.root.join('seed', 'data', 'event.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export channels"
  task :channel_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Channel.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end

    File.open(Rails.root.join('seed', 'data', 'channel.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end

namespace :export do
  desc "Export playlists"
  task :playlist_to_seeds => :environment do
    FileUtils.mkdir_p(Rails.root.join('seed', 'data'))
    data = Playlist.all.map do |e|
      e.attributes.except('created_at', 'updated_at', 'id')
    end

    File.open(Rails.root.join('seed', 'data', 'playlist.yml'), 'w+') do |f|
      f.puts(YAML.dump(data))
    end
  end
end
