class User::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]
  respond_to :json

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # byebug
    super

    # if resource.persisted?
    #   save_user_avatar(resource)
    # end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
        :first_name,
        :last_name,
        :cellphone,
        :birthday,
        :sex,
        :nautical_professional,
        :academic_profile,
        :relationship,
        :about,
        :has_embarcation,
        :nautical_work,
        :naval_service
      ])
  end

  def avatar_params
    params.require(:sign_up).permit(
      :avatar
    )
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private
  def save_resource_avatar(resource)
    encoded_picture = avatar_params[:data]
    content_type = avatar_params[:content_type]
    image = Paperclip.io_adapters.for("data:#{content_type};base64,#{encoded_picture}")
    image.original_filename = avatar_params[:filename]
    resource.avatar = image
    resource.save
  end
end
