# frozen_string_literal: true

namespace :performance do
  desc "Initializes all the performances"
  task createPerformances: :environment do
    Channel.all.find_each do |channel|
      CreatePerformanceVideosJob.perform_later(channel.id)
    end
  end
end
