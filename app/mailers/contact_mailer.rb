# frozen_string_literal: true

class ContactMailer < ApplicationMailer
  def send_contact_email(contact)
    @contact = contact
    mail(to: "tangotubetv@gmail.com)", subject: "New Contact Message")
  end
end
