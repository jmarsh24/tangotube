# frozen_string_literal: true

class TestMail
  attr_reader :to, :from, :subject, :body

  def initialize(mail)
    @to = mail["to"]
    @from = mail["from"]
    @subject = mail.subject
    @original_body = mail.body.to_s
    @body = Nokogiri::HTML(mail.body.to_s)
  end

  def link_urls
    body.css("a").pluck("href")
  end
end

module MailHelper
  class NoMailSentError < StandardError; end

  def last_mail
    return nil unless ActionMailer::Base.deliveries.count > 0

    TestMail.new(ActionMailer::Base.deliveries.last)
  end

  def last_mail!
    last_mail || raise(NoMailSentError)
  end

  def reset_mails
    ActionMailer::Base.deliveries = []
  end

  def run_jobs
    # recursivly run the job queue until there are no jobs remaining
    count = perform_enqueued_jobs
    run_jobs if count.to_i > 0
  end
end

RSpec.configure do |config|
  config.before do
    ActionMailer::Base.deliveries = []
  end
  config.include MailHelper, type: :system
  config.include MailHelper, type: :model
end
