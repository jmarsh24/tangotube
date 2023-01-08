# frozen_string_literal: true

# Seed read Channels
data = YAML.load_file(Rails.root.join("seed", "data", "channel.yml").to_s)
data.each { |e| Channel.create!(e) }
Rails.logger.debug "There are now #{Channel.count} channels in the database."

# Seed read Playlists
data = YAML.load_file(Rails.root.join("seed", "data", "playlist.yml").to_s)
data.each { |e| Playlist.create!(e) }
Rails.logger.debug "There are now #{Playlist.count} playlists in the database."

# Seed read Events
data = YAML.load_file(Rails.root.join("seed", "data", "event.yml").to_s)
data.each { |e| Event.create!(e) }
Rails.logger.debug "There are now #{Event.count} events in the database."

# Seed read Leaders
data = YAML.load_file(Rails.root.join("seed", "data", "leader.yml").to_s)
data.each { |e| Dancer.create!(e) }
Rails.logger.debug "There are now #{Dancer.count} dancers in the database."

# Seed read Followers
data = YAML.load_file(Rails.root.join("seed", "data", "follower.yml").to_s)
data.each { |e| Dancer.create!(e) }
Rails.logger.debug "There are now #{Dancer.count} dancers in the database."

# Seed read Videos
data = YAML.load_file(Rails.root.join("seed", "data", "song.yml").to_s)
data.each { |e| Song.create!(e) }
Rails.logger.debug "There are now #{Song.count} songs in the database."

# Seed read Videos
data = YAML.load_file(Rails.root.join("seed", "data", "videos.yml").to_s)
data.each { |e| Video.create!(e) }
Rails.logger.debug "There are now #{Video.count} videos in the database."

# Seed Admin User in Development
Rails.logger.debug "Seeding admin user into database"
if Rails.env.development?
  User.create!(
    email: "admin@example.com",
    first_name: "admin",
    last_name: "example",
    password: "password"
  ).admin!
end
