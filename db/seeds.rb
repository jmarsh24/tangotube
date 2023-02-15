# frozen_string_literal: true

# Seed Admin User in Development
Rails.logger.debug "Seeding admin user into database"

if Rails.env.development?
  user = User.create(
    first_name: "Admin",
    last_name: "User",
    email: "admin@tangotube.tv",
    password: "password",
    password_confirmation: "password"
  )
  user.skip_confirmation!
  user.save!
  user.admin!
end
