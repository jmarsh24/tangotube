class RefreshMaterializedViewJob < ApplicationJob
  queue_as :low_priority

  def perform
    VideoSearch.refresh
  end
end
