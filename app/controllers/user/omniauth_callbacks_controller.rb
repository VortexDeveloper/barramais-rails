require 'base64'

class User::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  def facebook
    if params[:cordova].present?
      facebook_from_cordova(params[:cordova])
    else
      facebook_from_omniauth
    end
  end

  def facebook_from_omniauth
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook_from_cordova(token)
    auth = JSON.parse(Base64.decode64(token))
    @user = User.from_facebook4(auth)

    if @user.persisted?
      respond_with @user do |format|
        format.json do
          render json: {
            user: JWTWrapper.encode(resource.user_hash),
            token: JWTWrapper.encode({id: resource.id}),
            vessels_type: VesselType.all.as_json
          }
        end
      end
    else
      render json: {errors: {avatar: ['não foi possível salvar']}}.to_json, status: 500
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
