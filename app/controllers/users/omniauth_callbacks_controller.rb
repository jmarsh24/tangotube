class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth "Google"
  end

  def facebook
    handle_auth "Facebook"
  end

  def handle_auth(kind)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      flash[:error]="There was a problem signing you in through #{kind}. Please register or try signing in later."
      redirect_to new_user_registration_url
    end
  end

  def redirect
      oauth_client = Patreon::OAuth.new(client_id, client_secret)
      tokens = oauth_client.get_tokens(params[:code], redirect_uri)
      access_token = tokens['access_token']

      api_client = Patreon::API.new(access_token)
      user_response = api_client.fetch_user()
      # user_response uses [json-api-vanilla](https://github.com/trainline/json-api-vanilla) for easy usage
      @user = user_response.data
      # you can list all attributes and relationships with (@user.methods - Object.methods)
      @pledge = @user.pledges[0]
      # just like with @user, you can list all pledge attributes and relationships with (@pledge.methods - Object.methods)
      @pledge_amount = @pledge.amount_cents
  end
end
