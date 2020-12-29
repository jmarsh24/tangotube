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
  Video.match_all_dancers
  puts 'done.'
end
desc 'This task populates videos'
task match_all_music: :environment do
  puts 'Matching music with ACR Cloud'
  Video.match_all_music
  puts 'done.'
end
