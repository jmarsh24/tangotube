# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Shimmer::Consent
  include Shimmer::RemoteNavigation
  include Shimmer::FileHelper

  default_form_builder Shimmer::Form::Builder

  helper_method :show_filter_bar?

  before_action :check_supporter

  def check_supporter
    @show_support_modal = current_user && !current_user&.supporter
  end

  private

  def paginated(scope, per: 12, frame_id: "pagination-frame")
    @current_page = params[:page]&.to_i || 1
    scope = scope.page(@current_page).per(per)
    @has_more_pages = !scope.next_page.nil? unless @has_more_pages == true
    if @current_page > 1
      ui.remove "next-page-link-#{frame_id}"
      ui.append frame_id, with: "components/pagination", items: scope, partial: params[:partial], frame_id:
    end
    scope
  end

  def show_filter_bar?
    false
  end
end
