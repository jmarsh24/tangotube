require 'csv'

CSV.foreach('data/tangodb-datasets/songs.csv', headers: true) do |column|
  genre = column[1]
  title = column[2]
  artist = column[3]
  artist_2 = column[6]
  composer = column[7]
  author = column[8]
  date = column[9]
  last_name_search = column[10]
  occur_count = column[11]
  popularity = column[12]
  active = column[13]
  lyrics = column[14]
  Song.create(genre: genre, title: title, artist: artist, artist_2: artist_2,
              composer: composer, author: author, date: date,
              last_name_search: last_name_search,
              popularity: popularity, active: active, lyrics: lyrics)
end
puts "There are now #{Song.count} Songs in the database."

puts 'Seeding process started'

CSV.foreach('data/tangodb-datasets/Leaders.csv', headers: true) do |column|
  name = column[1]
  reviewed = column[4]
  nickname = column[5]
  first_name = column[6]
  last_name = column[7]

  Leader.create(name: name, reviewed: reviewed, nickname: nickname, first_name: first_name, last_name: last_name)
end
puts "There are now #{Leader.count} leaders in the database."

puts 'Seeding followers into database'

CSV.foreach('data/tangodb-datasets/Followers.csv', headers: true) do |column|
  name = column[1]
  reviewed = column[4]
  nickname = column[5]
  first_name = column[6]
  last_name = column[7]
  Follower.create(name: name, reviewed: reviewed, nickname: nickname, first_name: first_name, last_name: last_name)
end
puts "There are now #{Follower.count} followers in the database."

CSV.foreach('data/tangodb-datasets/channels.csv', headers: true) do |column|
  title = column[1]
  channel_id = column[2]
  imported = column[5]
  imported_videos_count = column[6]
  total_videos_count = column[7]
  yt_api_pull_count = column[8]
  reviewed = column[9]
  Channel.create(title: title, channel_id: channel_id, reviewed: reviewed)
end
puts "There are now #{Channel.count} channels in the database."

# Seed read
data = YAML.load_file(Rails.root.join('seed', 'data', 'video.yml').to_s)
data.each do |e|
  Video.create!(e)
end
puts "There are now #{Video.count} videos in the database."

puts 'Seeding admin user into database'

if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

puts 'Admin User successfully seeded.'
