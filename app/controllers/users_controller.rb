class UsersController < ApplicationController
  before_action :set_user

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :cellphone,
      :birthday,
      :sex,
      :nautical_professional,
      :academic_profile,
      :relationship,
      :user_id,
      :about,
      :has_embarcation,
      :nautical_work,
      :naval_service
    )
  end
end
