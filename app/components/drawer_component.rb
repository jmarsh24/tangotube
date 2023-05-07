# frozen_string_literal: true

class DrawerComponent < ViewComponent::Base
  def initialize(user_signed_in:)
    @user_signed_in = user_signed_in
  end
end
