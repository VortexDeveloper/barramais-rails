class GroupsController < ApplicationController
  before_action :set_group, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :save_cover_photo,
    :all_members,
    :confirmed_members,
    :pending_by_user,
    :pending_by_admin,
    :refused_members,
    :invitation
  ]
  before_action :authenticate_user!, only: [:create, :update]

  #Resposta JSON Padrão
  def respond_for response, status=200
    respond_to do |format|
      format.json { render json: response.to_json, status: status }
    end
  end

  def all_members
    @all_members = @group.members
  end

  def confirmed_members
    @confirmed_members = @group.confirmed_members
  end

  def pending_by_user
    @pending_by_user = @group.pending_by_user
  end

  def pending_by_admin
    @pending_by_admin = @group.pending_by_admin
  end

  def refused_members
    @refused_members = @group.refused_members
  end

  #Convida usuário e retorna lista de convidados atualizada
  def invitation
    begin
      params[:members].each do |member|
        user = User.find(member[:id])
        @group.members << user
        group_member = GroupMember.where(member_id: user.id, group_id: @group.id).first
        group_member.group_member!
      end
      response = { members: @group.members.order(:first_name) }
      respond_for response
    rescue ActiveRecord::RecordInvalid => e
      response = { error: e.message }
      respond_for response, 409
    rescue => e
      response = { error: e.message }
      respond_for response
    end
  end

  def save_cover_photo
    image = Paperclip.io_adapters.for(cover_photo_params[:image])
    image.original_filename = "#{cover_photo_params[:filename]}"
    @group.cover_photo = image

    respond_to do |format|
      if @group.save
        format.html {}
        format.json do
          render json: @group
        end
      else
        format.html {}
        format.json { render json: {errors: {cover_photo: ['não foi possível salvar']}}.to_json }
      end
    end
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
    @group.user = current_user
    respond_to do |format|
      if @group.save
        @group.members << current_user
        current_user.accept_group @group
        image = Paperclip.io_adapters.for(cover_photo_params[:image])
        image.original_filename = "#{cover_photo_params[:filename]}"
        @group.cover_photo = image
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
        format.json { render @group }
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
