# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Shimmer::Consent
  include Shimmer::RemoteNavigation
  include Shimmer::FileHelper

  default_form_builder Shimmer::Form::Builder

  before_action :check_supporter

  def check_supporter
    @show_support_modal = current_user && !current_user&.supporter
  end

  def require_turbo_frame
    head :unprocessable_entity unless turbo_frame_request?
  end

  private

  def paginated(scope, per: 24, frame_id: "pagination-frame")
    @current_page = params[:page]&.to_i || 1
    scope = scope.page(@current_page).per(per).without_count
    @has_more_pages = !scope.next_page.nil? unless @has_more_pages == true
    respond_to do |format|
      format.html
      format.turbo_stream do
        if @current_page > 1
          ui.remove "next-page-link-#{frame_id}"
          ui.append frame_id, with: "components/pagination", items: scope, partial: params[:partial], frame_id:
        end
      end
    end
    scope
  end

  def is_bot?
    browser = Browser.new(request.user_agent)
    browser.bot?
  end
end
