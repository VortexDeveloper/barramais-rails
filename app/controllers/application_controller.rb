class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verified_request?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def verified_request?
    if request.content_type == "application/json"
      true
    else
      super
    end
  end

  def configure_permitted_parameters
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
        :nautical_profession_description,
        :naval_service
      ])
  end
end
