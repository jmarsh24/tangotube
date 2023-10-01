# frozen_string_literal: true

class RefreshVideoScoresJob < ApplicationJob
  queue_as :refresh

  def perform
    ActiveRecord::Base.connection.execute("SET statement_timeout TO '5min';")

    VideoScore.refresh

    ActiveRecord::Base.connection.execute("RESET statement_timeout;")
  end
end
