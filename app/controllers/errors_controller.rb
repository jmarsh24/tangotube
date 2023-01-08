# frozen_string_literal: true

class ErrorsController < ApplicationController
  before_action :assign_exception
  before_action :capture_exception

  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end

  private

  def assign_exception
    @exception = request.env["action_dispatch.exception"]
  end

  def capture_exception
    Rails.error.report(@exception, handled: true)
  end
end
