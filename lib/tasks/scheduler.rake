desc 'This task populates videos'
task import_all_channels: :environment do
  puts 'Populating videos from channels'
  Video.import_all_channels
  puts 'done.'
end

desc 'This task populates videos'
task match_all_songs: :environment do
  puts 'Matching songs'
  Video.match_all_songs
  puts 'done.'
end

desc 'This task populates videos'
task match_all_dancers: :environment do
  puts 'Matching dancers'
  Video.match_all_leaders
  Video.match_all_followers
  puts 'done.'
end

desc 'This task populates videos'
task match_all_music: :environment do
  puts 'Fetching all missing music matches with ACR Cloud'
  Video.fetch_all_acr_cloud_matches
  puts 'done.'
end

desc 'This task fetches music data which exists on youtube'
task fetch_all_youtube_matches: :environment do
  puts 'Fetching all missing youtube matches'
  Video.fetch_all_youtube_matches
  puts 'done.'
end

desc 'This task populates videos'
task update_imported_video_counts: :environment do
  puts 'Updating imported video counts'
  Video.update_imported_video_counts
  puts 'done.'
end

desc 'This task populates playlists'
task update_imported_video_counts: :environment do
  puts 'Adding all new playlists'
  Video.import_all_playlists
  puts 'done.'
end

namespace :refreshers do
  desc 'Refresh materialized view for Videos'
  task videos_searches: :environment do
    VideosSearch.refresh
  end
end
