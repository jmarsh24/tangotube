require "csv"

CSV.foreach("data/tangodb-datasets/Songs.csv", headers: true) do |column|
  genre = column[0]
  title = column[1]
  artist = column[2]
  Song.create(genre: genre, title: title, artist: artist)
end
puts "There are now #{Song.count} Songs in the database."

CSV.foreach("data/tangodb-datasets/Videotypes.csv", headers: true) do |column|
  name = column[1]
  Videotype.create(name: name)
end
puts "There are now #{Videotype.count} videotypes in the database."

CSV.foreach("data/tangodb-datasets/Events.csv", headers: true) do |column|
  name = column[1]
  Event.create(name: name)
end
puts "There are now #{Event.count} events in the database."

CSV.foreach("data/tangodb-datasets/Leaders.csv", headers: true) do |column|
  name = column[1]
  Leader.create(name: name)
end
puts "There are now #{Leader.count} leaders in the database."

CSV.foreach("data/tangodb-datasets/Followers.csv", headers: true) do |column|
  name = column[1]
  Follower.create(name: name)
end
puts "There are now #{Follower.count} followers in the database."

# Seed raw json data for videos without relations
# CSV.foreach('data/tangodb-datasets/Videos-videos_dataset_master.csv', headers: true) do |column|
#   title           = column[3]
#   youtube_id      = column[4]
#   description     = column[7]
#   channel         = column[8]
#   channel_id      = column[9]
#   duration        = column[10]
#   upload_date     = column[11]
#   view_count      = column[12]
#   avg_rating      = column[13]
#   tags            = column[14]
#   youtube_song    = column[16]
#   youtube_artist  = column[17]
#   Video.create( title:          title,
#                 youtube_id:     youtube_id,
#                 description:    description,
#                 channel:        channel,
#                 channel_id:     channel_id,
#                 duration:       duration,
#                 upload_date:    upload_date,
#                 view_count:     view_count,
#                 avg_rating:     avg_rating,
#                 tags:           tags,
#                 youtube_song:   youtube_song,
#                 youtube_artist: youtube_artist )
# end
# puts "There are now #{Video.count} videos in the database."

# Seeding data with relations
CSV.foreach("data/tangodb-datasets/videos.csv", headers: true) do |column|
  title = column[1]
  youtube_id = column[2]
  leader_id = column[3]
  follower_id = column[4]
  description = column[5]
  channel = column[6]
  channel_id = column[7]
  duration = column[8]
  upload_date = column[9]
  view_count = column[10]
  avg_rating = column[11]
  tags = column[12]
  song_id = column[13]
  youtube_song = column[14]
  youtube_artist = column[15]
  videotype_id = column[19]
  event_id = column[20]
  Video.create(title: title,
               youtube_id: youtube_id,
               leader_id: leader_id,
               follower_id: follower_id,
               description: description,
               channel: channel,
               channel_id: channel_id,
               duration: duration,
               upload_date: upload_date,
               view_count: view_count,
               avg_rating: avg_rating,
               tags: tags,
               song_id: song_id,
               youtube_song: youtube_song,
               youtube_artist: youtube_artist,
               videotype_id: videotype_id,
               event_id: event_id)
end
puts "There are now #{Video.count} videos with relations in the database."

AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password") if Rails.env.development?
