class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth "Google"
  end

  def facebook
    handle_auth "Facebook"
  end

  def handle_auth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind:) if is_navigational_format?
    else
      flash[:error]="There was a problem signing you in through #{kind}. Please register or try signing in later."
      redirect_to new_user_registration_url
    end
  end
end
