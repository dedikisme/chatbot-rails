class StemmingsController < ApplicationController
  before_action :set_stemming, only: [:show, :edit, :update, :destroy]

  # GET /stemmings
  # GET /stemmings.json
  def index
    @stemmings = Stemming.all
  end

  # GET /stemmings/1
  # GET /stemmings/1.json
  def show
  end

  # GET /stemmings/new
  def new
    @stemming = Stemming.new
  end

  # GET /stemmings/1/edit
  def edit
  end

  # POST /stemmings
  # POST /stemmings.json
  def create
    @stemming = Stemming.new(stemming_params)

    respond_to do |format|
      if @stemming.save
        format.html { redirect_to @stemming, notice: 'Stemming was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stemming }
      else
        format.html { render action: 'new' }
        format.json { render json: @stemming.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stemmings/1
  # PATCH/PUT /stemmings/1.json
  def update
    respond_to do |format|
      if @stemming.update(stemming_params)
        format.html { redirect_to @stemming, notice: 'Stemming was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stemming.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stemmings/1
  # DELETE /stemmings/1.json
  def destroy
    @stemming.destroy
    respond_to do |format|
      format.html { redirect_to stemmings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stemming
      @stemming = Stemming.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stemming_params
      params.require(:stemming).permit(:type, :keywords, :ganti, :kodisi)
    end
end
