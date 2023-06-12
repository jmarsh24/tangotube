# frozen_string_literal: true

class ImportNewVideosForAllChannelsJob < ApplicationJob
  queue_as :default

  def perform
    Channel.active.find_each(&:import_new_videos)
  end
end
