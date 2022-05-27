ActionMailer::Base.smtp_settings = {
  domain:         "tangotube.tv",
  address:        "smtp.sendgrid.net",
  port:            587,
  authentication: :plain,
  user_name:      'apikey',
  password:       Rails.application.credentials.dig(:sendgrid, :api_key)
}
