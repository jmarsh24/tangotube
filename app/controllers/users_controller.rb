class UsersController < ApplicationController
  before_action :allow_without_password, only: [:update]

  private

  def allow_without_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end
end
