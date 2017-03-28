require 'jwt_wrapper'
class User::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]
  respond_to :html, :json

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource do |format|
      format.html { redirect_to after_sign_in_path_for(resource) }
      format.json do
        user_hash = resource.as_json
        user_hash.merge!({avatar_url: helpers.asset_url(resource.avatar.url)})
        render json: {user: JWTWrapper.encode(user_hash), token: JWTWrapper.encode({id: resource.id})}
      end
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

end
