# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactMailer.send_contact_email(@contact).deliver_later
      flash[:success] = t(".thank_you_for_reaching_out")
      redirect_to root_path
    else
      flash.now[:error] = t(".there_was_an_error_with_your_submission")
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
