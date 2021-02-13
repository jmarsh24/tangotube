require 'csv'

puts 'Seeding process started'

# CSV.foreach('data/tangodb-datasets/el_recodo_songs.csv', headers: true) do |column|
#   date = column[0]
#   artist = column[1]
#   title = column[2]
#   artist_2 = column[3]
#   style = column[4]
#   composer = column[5]
#   author = column[6]
#   last_name_search = column[7]
#   Song.create(date: date, artist: artist, title: title, artist_2: artist_2, genre: style, composer: composer,
#               author: author, last_name_search: last_name_search)
# end
# puts "There are now #{Song.count} Songs in the database."

# puts 'Seeding process started'

# CSV.foreach('data/tangodb-datasets/solotango_music_seed.csv', headers: false) do |column|
#   genre = column[0]
#   title = column[1]
#   artist = column[2]
#   last_name_search = column[5]
#   Song.create(artist: artist, title: title, genre: genre, last_name_search: last_name_search)
# end
# puts "There are now #{Song.count} Songs in the database."

# puts 'Seeding leaders into database'

# CSV.foreach('data/tangodb-datasets/Leaders.csv', headers: true) do |column|
#   name = column[1]
#   Leader.create(name: name)
# end
# puts "There are now #{Leader.count} leaders in the database."

# puts 'Seeding followers into database'

# CSV.foreach('data/tangodb-datasets/Followers.csv', headers: true) do |column|
#   name = column[1]
#   Follower.create(name: name)
# end
# puts "There are now #{Follower.count} followers in the database."

# CSV.foreach('data/tangodb-datasets/channels.csv', headers: true) do |column|
#   title = column[1]
#   channel_id = column[2]
#   Channel.create(title: title, channel_id: channel_id)
# end
# puts "There are now #{Channel.count} channels in the database."

# puts 'Seeding admin user into database'

# if Rails.env.development?
#   AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
# end

# puts 'Admin User successfully seeded.'

CSV.foreach('data/tangodb-datasets/youtube_song_update.csv', headers: false) do |column|
  id = column[0]
  youtube_song = column[1]
  youtube_artist = column[2]
  video = Video.find(id)
  video.update(youtube_song: youtube_song, youtube_artist: youtube_artist)
end

puts 'Succesfully seeded youtube music update into database'
