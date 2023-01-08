# frozen_string_literal: true

namespace :jobs do
  desc "Clear all enqueued jobs (by clearing the Redis database used by Sidekiq)"
  task clear: :environment do
    Sidekiq.redis(&:flushdb)
  end

  desc "Set all jobs to be inlined (bypass the configured ActiveJob Queue Adapter)"
  task inline: :environment do
    ActiveJob::Base.queue_adapter = InlineIgnoreScheduledActiveJobsAdapter.new
  end
end
