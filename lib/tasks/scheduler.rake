desc 'This task populates videos'
task import_videos: :environment do
  puts 'Populating videos'
  Video.import_all_videos
  puts 'done.'
end

desc 'This task populates videos'
task match_songs: :environment do
  puts 'Populating songs'
  Video.match_songs
  puts 'done.'
end

desc 'This task populates videos'
task match_dancers: :environment do
  puts 'Populating songs'
  Video.match_dancers
  puts 'done.'
end
