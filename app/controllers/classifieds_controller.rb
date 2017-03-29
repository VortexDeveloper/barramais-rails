class ClassifiedsController < ApplicationController
  before_action :set_classified, only: [:show, :edit, :update, :destroy, :molds_for_select]

  #Resposta JSON Padrão
  def respond_for response, status=200
    respond_to do |format|
      format.json { render json: response.to_json, status: status }
    end
  end

  def brands_for_select
    response = { brands: Brand.all }
    respond_for response
  end

  def molds_for_select
    response = { molds: Mold.where(brand_id: params[:id]).order(:name) }
    respond_for response
  end

  def accessories_for_select
    @accessories = Accessory.where(accessory_type: 0)
  end

  def communications_for_select
    @accessories = Accessory.where(accessory_type: 1)
  end

  def eletronics_for_select
    @accessories = Accessory.where(accessory_type: 2)
  end

  # GET /classifieds
  # GET /classifieds.json
  def index
    @classifieds = Classified.all
  end

  # GET /classifieds/1
  # GET /classifieds/1.json
  def show
  end

  # GET /classifieds/new
  def new
    @classified = Classified.new
  end

  # GET /classifieds/1/edit
  def edit
  end

  # POST /classifieds
  # POST /classifieds.json
  def create
    @classified = Classified.new(classified_params)

    respond_to do |format|
      if @classified.save
        format.html { redirect_to @classified, notice: 'Classified was successfully created.' }
        format.json { render :show, status: :created, location: @classified }
      else
        format.html { render :new }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classifieds/1
  # PATCH/PUT /classifieds/1.json
  def update
    respond_to do |format|
      if @classified.update(classified_params)
        format.html { redirect_to @classified, notice: 'Classified was successfully updated.' }
        format.json { render :show, status: :ok, location: @classified }
      else
        format.html { render :edit }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classifieds/1
  # DELETE /classifieds/1.json
  def destroy
    @classified.destroy
    respond_to do |format|
      format.html { redirect_to classifieds_url, notice: 'Classified was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classified
      @classified = Classified.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classified_params
      params.require(:classified).permit(
        :title,
        :document_type,
        :document_number,
        :seller_name,
        :email,
        :landline,
        :cell_phone,
        :description,
        :price,
        :user_id
      )
    end
end
