class UsersController < ApplicationController
  before_action :allow_without_password, only: [:update]

  def create
    @user = User.new(user_params)
    # don't send email notifications from admin interface
    @user.skip_notifications!
    # ...
  end

  def update
    # don't send email notifications from admin interface
    @user.skip_notifications!
    # ...
  end

  def savenew
    sql = "insert into users (name,email, created_at,updated_at) values(
          #{ActiveRecord::Base.connection.quote(user_params[:name])},
          #{ActiveRecord::Base.connection.quote(user_params[:email])},now(), now())"
    ActiveRecord::Base.connection.execute(sql)
    redirect_to action: "index"
  end

  private

  def allow_without_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end
end
