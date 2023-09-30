# frozen_string_literal: true

class UpdateActiveChannelsJob < ApplicationJob
  queue_as :update

  def perform
    Channel.active.find_each(&:fetch_and_save_metadata_later!)
  end
end
