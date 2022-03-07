class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.set_payment_processor :stripe
    current_user.pay_customers
    @checkout_session = current_user.payment_processor.checkout(
      mode: "subscription",
      line_items: "price_1KacxjCOXOTU8ZRQbvw5lzB1"
    )
  end
end
