namespace :dancer do
  task :create_orchestras => :environment do
    Song.all.find_each do |song|
     orchestra = Orchestra.create(name: song.artist)
      song.orchestra = orchestra
    end
  end
end
