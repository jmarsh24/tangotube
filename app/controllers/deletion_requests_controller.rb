# frozen_string_literal: true

class DeletionRequestsController < ApplicationController
  # disable CSRF protection, as it doesn't make sense in this case
  protect_from_forgery with: :null_session

  def facebook
    DeletionRequest
      .from_signed_fb(params["signed_request"])
      .run

    render json: {
      url: deletion_request_url(dr.pid),
      confirmation_code: dr.pid
    }
  end

  def show
    dr = DeletionRequest.find_by!(pid: params[:id])
    render text: if dr.deleted?
                   "Your data has been completely deleted"
                 else
                   "Your deletion request is still in progress"
                 end
  end
end
