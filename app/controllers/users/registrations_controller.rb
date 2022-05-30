class Users::RegistrationsController < Devise::RegistrationsController

  private

  def update_resource(resource, account_update_params)
    resource.update_without_password(account_update_params)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :avatar)
  end
end
