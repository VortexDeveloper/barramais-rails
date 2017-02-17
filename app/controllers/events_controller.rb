class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :save_cover_photo, :invitation]


  def save_cover_photo event
    image = Paperclip.io_adapters.for(cover_photo_params[:image])
    image.original_filename = "#{cover_photo_params[:filename]}"
    event.cover_photo = image
    event.save
  end

  def country_for_select
    response = { countrys: Country.all }
    respond_for response
  end

  def cities_for_select
    response = { cities: City.where(state_id: params[:id]).order(:name) }
    respond_for response
  end

  def states_for_select
    response = { states: State.where(country_id: params[:id]).order(:name) }
    respond_for response
  end

  def respond_for response
    respond_to do |format|
      format.json { render json: response.to_json }
    end
  end

  def invitation
    user = User.find(params[:user])
    @event.users << user
    response = { event_users: @event.users }
    respond_for response
  end

  # GET /events
  # GET /events.json
  def index
    @events = { events: Event.all }
    respond_to do |format|
      format.json { render json: @events.to_json }
      format.html { render :index }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.create_address(address_params)
    respond_to do |format|
      if @event.save
        save_cover_photo(@event)
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event.to_json }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(
        :user_id,
        :name,
        :event_date,
        :about,
        :address_id,

      )
    end

    def cover_photo_params
      params.require(:cover_photo).permit(
        :image,
        :filename
      )
    end

    def address_params
      params.require(:address).permit(
        :street,
        :complement,
        :neighborhood,
        :city_id,
        :state_id,
        :country_id,
        :zip_code,
        :event_id
      )
    end

    def user_params
      params.require(:user).permit(
        :user_id
      )
    end
end
