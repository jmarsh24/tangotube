# frozen_string_literal: true

class SystemStatusController < ApplicationController
  before_action :authenticate_user!

  # @route GET /status (status)
  def show
    status = SystemStatus.new
    render plain: status.component_status.map { |k, v| [k, v].join(": ") }.join("\n"), status: status.all_ok? ? :ok : :service_unavailable
  end
end
