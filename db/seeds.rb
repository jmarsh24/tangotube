# Seed read Channels
data = YAML.load_file(Rails.root.join('seed', 'data', 'channel.yml').to_s)
data.each do |e|
  Channel.create!(e)
end
puts "There are now #{Channel.count} channels in the database."

# Seed read Videos
data = YAML.load_file(Rails.root.join('seed', 'data', 'videos.yml').to_s)
data.each do |e|
  Video.create!(e)
end
puts "There are now #{Video.count} videos in the database."

# Seed read Leaders
data = YAML.load_file(Rails.root.join('seed', 'data', 'leader.yml').to_s)
data.each do |e|
  Leader.create!(e)
end
puts "There are now #{Leader.count} leaders in the database."

# Seed read Followers
data = YAML.load_file(Rails.root.join('seed', 'data', 'follower.yml').to_s)
data.each do |e|
  Follower.create!(e)
end
puts "There are now #{Follower.count} followers in the database."

# Seed read Events
data = YAML.load_file(Rails.root.join('seed', 'data', 'event.yml').to_s)
data.each do |e|
  Event.create!(e)
end
puts "There are now #{Event.count} events in the database."

# Seed read Playlists
data = YAML.load_file(Rails.root.join('seed', 'data', 'playlist.yml').to_s)
data.each do |e|
  Playlist.create!(e)
end
puts "There are now #{Playlist.count} playlists in the database."

# Seed read Video Searches
data = YAML.load_file(Rails.root.join('seed', 'data', 'videos_search.yml').to_s)
data.each do |e|
  VideosSearch.create!(e)
end
puts "There are now #{VideosSearch.count} videos searches in the database."

# Seed Admin User in Development
puts 'Seeding admin user into database'
if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end
