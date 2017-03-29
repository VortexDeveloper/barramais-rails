class GroupsController < ApplicationController
  before_action :set_group, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :save_cover_photo,
    :all_members,
    :confirmed_members,
    :pending_members,
    :refused_members,
    :invitation
  ]
  before_action :authenticate_user!, only: [:create]

  #Resposta JSON Padrão
  def respond_for response, status=200
    respond_to do |format|
      format.json { render json: response.to_json, status: status }
    end
  end

  def all_members
    response = { all_members: @group.members }
    respond_for response
  end

  def confirmed_members
    response = { confirmed_members: @group.confirmed_members }
    respond_for response
  end

  def pending_members
    response = { pending_members: @group.pending_members }
    respond_for response
  end

  def refused_members
    response = { refused_members: @group.refused_members }
    respond_for response
  end

  #Convida usuário e retorna lista de convidados atualizada
  def invitation
    begin
      params[:members].each do |member|
        @group.members << User.find(member[:id])
      end
      response = { members: @group.members.order(:first_name) }
      respond_for response
    rescue ActiveRecord::RecordInvalid => e
      response = { error: e.message }
      respond_for response, 409
    rescue e
      response = { error: e.message }
      respond_for response
    end
  end

  #Salvar imagem de capa
  def save_cover_photo group
    image = Paperclip.io_adapters.for(cover_photo_params[:image])
    image.original_filename = "#{cover_photo_params[:filename]}"
    group.cover_photo = image
    group.save
  end

  # GET /groups
  # GET /groups.json
  def index
    response = { groups: Group.all }
    respond_to do |format|
      format.json { render json: response.to_json }
      format.html { render :index }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        @group.members << current_user
        current_user.accept_group @group
        save_cover_photo(@group)
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(
        :user_id,
        :name,
        :event_date,
        :about,
        :address,
      )
    end

    def cover_photo_params
      params.require(:cover_photo).permit(
        :image,
        :filename
      )
    end

    def user_params
      params.require(:user).permit(
        :user_id
      )
    end



end
