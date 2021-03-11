desc 'This task populates videos'
task import_all_reviewed_channels: :environment do
  puts 'Populating videos from channels'
  Channel.not_imported.reviewed.find_each do |channel|
    Video::YoutubeImport.from_channel(channel.channel_id)
  end
  puts 'done.'
end

desc 'This task populates playlists'
task import_all_playlists: :environment do
  puts 'Adding all new playlists'
  Playlist.not_imported.reviewed.find_each do |playlist|
    Video.import_playlist(playlist.slug)
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

namespace :export do
  desc "Export videos"
  task :export_videos_to_seeds => :environment do
    Video.all.each do |videos|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = videos
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Video.create(#{serialized})"
    end
  end
end

namespace :export do
  desc "Export leaders"
  task :export_leaders_to_seeds => :environment do
    Leader.all.each do |leaders|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = leaders
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Leader.create(#{serialized})"
    end
  end
end

namespace :export do
  desc "Export followers"
  task :export_followers_to_seeds => :environment do
    Follower.all.each do |followers|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = followers
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Follower.create(#{serialized})"
  end
  end
end

namespace :export do
  desc "Export songs"
  task :export_songs_to_seeds => :environment do
    Song.all.each do |songs|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = songs
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Song.create(#{serialized})"
    end
  end
end

namespace :export do
  desc "Export events"
  task :export_events_to_seeds => :environment do
    Event.all.each do |events|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = events
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Event.create(#{serialized})"
    end
  end
end

namespace :export do
  desc "Export channels"
  task :export_channels_to_seeds => :environment do
    Channel.all.each do |channels|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = channels
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Channel.create(#{serialized})"
    end
  end
end

namespace :export do
  desc "Export playlists"
  task :export_playlists_to_seeds => :environment do
    Playlist.all.each do |playlists|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = playlists
        .serializable_hash
        .delete_if{|key,value| excluded_keys.include?(key)}
      puts "Playlist.create(#{serialized})"
    end
  end
end

namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump --host #{host} --username #{user} --verbose --clean --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end

end


namespace :refreshers do
  desc 'Refresh materialized view for Videos'
  task videos_searches: :environment do
    VideosSearch.refresh
  end
end
