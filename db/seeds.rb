# frozen_string_literal: true

# Seed read Channels
if Channel.all.size > 0
  Rails.logger.debug "There are already #{Channel.count} channels in the database."
else
  data = YAML.load_file(Rails.root.join("seed", "data", "channel.yml").to_s)
  data.each { |e| Channel.create!(e) }
  Rails.logger.debug "There are now #{Channel.count} channels in the database."
end

# Seed read Playlists
if Playlist.all.size > 0
  Rails.logger.debug "There are already #{Playlist.count} playlists in the database."
else
  data = YAML.load_file(Rails.root.join("seed", "data", "playlist.yml").to_s)
  data.each { |e| Playlist.create!(e) }
  Rails.logger.debug "There are now #{Playlist.count} playlists in the database."
end

# Seed read Events
if Event.all.size > 0
  Rails.logger.debug "There are already #{Event.count} eventss in the database."
else
  data = YAML.load_file(Rails.root.join("seed", "data", "event.yml").to_s)
  data.each { |e| Event.create!(e) }
  Rails.logger.debug "There are now #{Event.count} events in the database."
end

if Dancer.all.size > 0
  Rails.logger.debug "There are already #{Dancer.count} dancers in the database."
else

  # Seed read Leaders
  data = YAML.load_file(Rails.root.join("seed", "data", "leader.yml").to_s)
  data.each { |e| Dancer.create!(e) }

  # Seed read Followers
  data = YAML.load_file(Rails.root.join("seed", "data", "follower.yml").to_s)
  data.each { |e| Dancer.create!(e) }

  Rails.logger.debug "There are now #{Dancer.count} dancers in the database."
end

# Seed read Videos
if Event.all.size > 0
  Rails.logger.debug "There are already #{Video.count} events in the database."
else
  data = YAML.load_file(Rails.root.join("seed", "data", "song.yml").to_s)
  data.each { |e| Song.create!(e) }
  Rails.logger.debug "There are now #{Video.count} videos in the database."
end

# Seed Admin User in Development
Rails.logger.debug "Seeding admin user into database"
if Rails.env.development?
  user = User.find_or_initialize_by(
    first_name: "Admin",
    last_name: "User",
    email: "admin@tangotube.tv",
    password: "password"
  )
  user.skip_confirmation!
  user.save!
end
