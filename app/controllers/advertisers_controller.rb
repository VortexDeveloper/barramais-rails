class AdvertisersController < ApplicationController
  before_action :set_advertiser, only: [:show, :edit, :update, :destroy]

  #Resposta JSON Padrão
  def respond_for response, status=200
    respond_to do |format|
      format.json { render json: response.to_json, status: status }
    end
  end

  #Seleção de países
  def country_for_select
    response = { countrys: Country.all }
    respond_for response
  end

  #Seleção de Estados baseado no país selecionado
  def states_for_select
    response = { states: State.where(country_id: params[:id]).order(:name) }
    respond_for response
  end

  #Seleção de Cidades baseado no estado selecionado
  def cities_for_select
    response = { cities: City.where(state_id: params[:id]).order(:name) }
    respond_for response
  end

  def my_address
    @address = @advertiser.address
  end

  def my_phones
    @phones = @advertiser.phones
  end

  # GET /advertisers
  # GET /advertisers.json
  def index
    @advertisers = Advertiser.all
  end

  # GET /advertisers/1
  # GET /advertisers/1.json
  def show
  end

  # GET /advertisers/new
  def new
    @advertiser = Advertiser.new
    @advertiser.address = Address.new
    @advertiser.landline = Landline.new
    @advertiser.cell_phone = CellPhone.new

  end

  # GET /advertisers/1/edit
  def edit
  end

  # POST /advertisers
  # POST /advertisers.json
  def create
    @advertiser = Advertiser.new(advertiser_params)
    @advertiser.create_address(address_params)
    #@advertiser.create_phone(phone_params)
    @advertiser.create_landline(landline_params)
    @advertiser.create_cell_phone(cell_phone_params)

    respond_to do |format|
      if @advertiser.save
        format.html { redirect_to @advertiser, notice: 'Advertiser was successfully created.' }
        format.json { render json: @advertiser.to_json }
      else
        format.html { render :new }
        format.json { render json: @advertiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advertisers/1
  # PATCH/PUT /advertisers/1.json
  def update
    respond_to do |format|
      if @advertiser.update(advertiser_params)
        format.html { redirect_to @advertiser, notice: 'Advertiser was successfully updated.' }
        format.json { render :show, status: :ok, location: @advertiser }
      else
        format.html { render :edit }
        format.json { render json: @advertiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisers/1
  # DELETE /advertisers/1.json
  def destroy
    @advertiser.destroy
    respond_to do |format|
      format.html { redirect_to advertisers_url, notice: 'Advertiser was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertiser
      @advertiser = Advertiser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertiser_params
      params.require(:advertiser).permit(
        :name,
        :document_type,
        :document_number,
        :email,
        :website,
        :facebook,
        :instagram
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
        :advertiser_id
      )
    end

    def landline_params
      params.require(:landline).permit(
        :number
      )
    end

    def cell_phone_params
      params.require(:cell_phone).permit(
        :number
      )
    end
end
