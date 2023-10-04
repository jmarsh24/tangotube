# frozen_string_literal: true

class RefreshVideoSearchesViewJob < ApplicationJob
  queue_as :refresh

  def perform
    ActiveRecord::Base.connection.execute("SET statement_timeout TO '5min';")
    begin
      VideoSearch.refresh
    ensure
      ActiveRecord::Base.connection.execute("RESET statement_timeout;")
    end
  end
end
