class UpdateActiveChannelsJob < ApplicationJob
  queue_as :default

  def perform
    Channel.active.find_each do |channel|
      channel.fetch_and_save_metadata_later!
    end
  end
end
