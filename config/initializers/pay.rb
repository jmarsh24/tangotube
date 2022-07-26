Pay.setup do |config|
  # For use in the receipt/refund/renewal mailers
  config.business_name = "TANGOTUBETV"
  config.business_address = "549 Main St"
  config.application_name = "TANGOTUBETV"
  config.support_email = "jmarsh24@gmail.com"

  config.default_product_name = "Subscription"
  config.default_plan_name = "Premium"

  config.automount_routes = true
  config.routes_path = "/pay" # Only when automount_routes is true
end
