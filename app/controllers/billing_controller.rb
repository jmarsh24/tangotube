class BillingController < ApplicationController
  before_action :authenticate_user!

  def show
    @portal_session = current_user.payment_processor.billing_portal
  end
end
