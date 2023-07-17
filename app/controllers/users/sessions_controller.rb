# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def new
    if request.format.turbo_stream?
      render layout: false
    end
  end
end
