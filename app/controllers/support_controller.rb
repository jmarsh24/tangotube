# frozen_string_literal: true

class SupportController < ApplicationController
  def show
    @show_support_modal = current_user && !current_user.supporter
  end
end
