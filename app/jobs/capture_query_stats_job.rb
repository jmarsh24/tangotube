# frozen_string_literal: true

class CaptureQueryStatsJob < ApplicationJob
  queue_as :refresh

  def perform
    PgHero.capture_query_stats
  end
end
