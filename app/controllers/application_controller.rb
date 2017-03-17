class ApplicationController < ActionController::Base
#  protect_from_forgery with: :exception

  protect_from_forgery with: :null_session
  before_action :verified_request?
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :html, :json


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
        :nautical_profession_description,
        :academic_profile,
        :relationship,
        :user_id,
        :about,
        :has_embarcation,
        :nautical_work,
        :naval_service,
        :naval_service_patent,
        :nautical_license,
        :has_nautical_license,
        :work
      ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
        :first_name,
        :last_name,
        :cellphone,
        :birthday,
        :sex,
        :nautical_professional,
        :nautical_profession_description,
        :academic_profile,
        :relationship,
        :user_id,
        :about,
        :has_embarcation,
        :nautical_work,
        :naval_service,
        :naval_service_patent,
        :nautical_license,
        :has_nautical_license,
        :work
      ])
  end
end
