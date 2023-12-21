# frozen_string_literal: true

class SyncAllChannelVideosJob < ApplicationJob
  queue_as :import

  def perform
    Channel.active.find_each do |channel|
      SyncVideosForChannelJob.perform_later(channel)
    end
  end
end
