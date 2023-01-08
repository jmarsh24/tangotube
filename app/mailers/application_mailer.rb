# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "support@tangotube.tv"
  layout "mailer"
end
