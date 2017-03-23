class UsersController < ApplicationController
  before_action :authenticate_user!, only: [
    :confirmed_events,
    :user_friends,
    :accept_friendship,
    :refuse_friendship,
    :request_friendship,
    :is_friend_of,
    :pending_friendships,
    :unfriend,
    :index
  ]

  before_action :set_user, except: [:index, :friends, :confirmed_events, :event_friends, :pending_friendships]

  def event_friends
    event = Event.find(params[:event])
    response = { users: User.where.not(id: event.all_guests) }
    respond_for response
  end

  def user_friends
    @friends = @user.accepted_friendships
  end

  # def pending_friends
  #   @pending_friends = current_user.pending_friends.order(:first_name)
  # end

  def accept_friendship
    current_user.accept_friendship_of @user
    response = { status: "Você e " + @user.first_name + " agora são amigos na b+!" }
    respond_for response
  end

  def refuse_friendship
    current_user.refuse_friendship_of @user
    response = { status: "Solicitação de amizade de " + @user.first_name + " recusado com sucesso!" }
    respond_for response
  end

  def request_friendship
    current_user.request_friendship_of @user
    response = { status: "Solicitação de amizade enviada a " + @user.first_name + " com sucesso!" }
    respond_for response
  end

  def is_friend_of
    response = current_user.friend_of? @user
    respond_for response
  end

  def pending_friendships
    @pending_friendships = current_user.pending_friendships
  end

  def unfriend
    current_user.unfriend @user
    response = { status: "Você não é mais amigo de " + @user.first_name + " na b+!" }
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
    @events = current_user.confirmed_events.order(:event_date)
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

  def index
    @users = User.where.not(id: current_user.id)
  end

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
      :nautical_profession_description,
      :academic_profile,
      :relationship,
      :user_id,
      :about,
      :has_embarcation,
      :nautical_work,
      :naval_service,
      :nautical_license,
      :has_nautical_license
    )
  end

  def avatar_params
    params.require(:avatar).permit(
    :image,
    :filename
    )
  end
end
