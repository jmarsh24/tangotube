desc 'This task populates videos'
task import_videos: :environment do
  puts 'Populating videos'
  Video.import_all_videos
  puts 'done.'
end

# task send_reminders: :environment do
#   User.send_reminders
# end
