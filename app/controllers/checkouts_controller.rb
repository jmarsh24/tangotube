# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.set_payment_processor :stripe
    current_user.pay_customers
    @tier_1 = current_user.payment_processor.checkout(
      mode: "subscription",
      line_items: "price_1Kaet3COXOTU8ZRQua1CoSnf"
    )
    @tier_2 = current_user.payment_processor.checkout(
      mode: "subscription",
      line_items: "price_1KaetrCOXOTU8ZRQoEnehPK8"
    )
    @tier_3 = current_user.payment_processor.checkout(
      mode: "subscription",
      line_items: "price_1KacxjCOXOTU8ZRQbvw5lzB1"
    )
  end
end
