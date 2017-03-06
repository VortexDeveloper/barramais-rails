class UsersController < ApplicationController
  before_action :set_user, except: [:index, :friends]

  def friends
    response = { users: User.all.order(:first_name) }
    respond_for response
  end

  def respond_for response
    respond_to do |format|
      format.json { render json: response.to_json }
    end
  end

  def user_advertiser
    @user.advertiser
    #response = { user_advertiser: @user.advertiser }
    #respond_for response
  end

  def save_avatar
    image = Paperclip.io_adapters.for(avatar_params[:image])
    image.original_filename = "#{avatar_params[:filename]}"
    @user.avatar = image

    respond_to do |format|
      if @user.save
        format.html {}
        format.json { render json: @user }
      else
        format.html {}
        format.json { render json: {errors: {avatar: ['não foi possível salvar']}}.to_json }
      end
    end
  end

  def my_events
    @events = @user.events.order(:event_date)
  end

  def confirmed_events
    @events = @user.confirmed_events.order(:event_date)
  end

  def pending_events
    @events = @user.pending_events.order(:event_date)
  end

  def refused_events
    @events = @user.refused_events.order(:event_date)
  end

  private

  def index
    @users = User.all
  end

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
      :nautical_profession_description,
      :academic_profile,
      :relationship,
      :user_id,
      :about,
      :has_embarcation,
      :nautical_work,
      :naval_service
    )
  end

  def avatar_params
    params.require(:avatar).permit(:image, :filename)
  end
end
