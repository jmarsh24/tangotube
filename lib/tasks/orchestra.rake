# frozen_string_literal: true

namespace :orchestra do
  desc "Create orchestras from existing songs" do
    task create_orchestras: :environment do
      Song.all.find_each do |song|
        orchestra = Orchestra.find_or_create_by(name: song.artist)
        song.orchestra = orchestra
        song.save
      end
    end
  end
end
