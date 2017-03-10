class UsersController < ApplicationController
  before_action :set_user, except: [:index, :friends]

  def friends
    event = Event.find(params[:event])
    response = { users: User.joins(:event_invitations).where(event_guests: {event_id: event.id}).where.not(id: event.all_guests) }
    # response = { users: User.all.order(:first_name) }
    respond_for response
  end

  def respond_for response
    respond_to do |format|
      format.json { render json: response.to_json }
    end
  end

  def user_advertiser
    @user.advertiser
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

  # def my_pending_invitations
  #   @invitations = @user.event_invitations.where(status: :pending).order(:created_at)
  # end
  #
  # def my_confirmed_invitations
  #   @invitations = @user.event_invitations.where(status: :accept).order(:created_at)
  # end
  #
  # def my_refused_invitations
  #   @invitations = @user.event_invitations.where(status: :refuse).order(:created_at)
  # end

  def accept_event
    event = Event.find(params[:event])
    @user.accept_event(event)
    response = { sucess: "Convite aceito!" }
    respond_for response
  end

  def refuse_event
    event = Event.find(params[:event])
    @user.refuse_event(event)
    response = { sucess: "Convite recusado!" }
    respond_for response
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
    params.require(:avatar).permit(
    :image,
    :filename
    )
  end
end
