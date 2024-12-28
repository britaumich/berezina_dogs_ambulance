class AviariesController < ApplicationController
  before_action :set_aviary, only: %i[ show edit update destroy ]

  # GET /aviaries or /aviaries.json
  def index
    @aviaries = Aviary.all
  end

  # GET /aviaries/1 or /aviaries/1.json
  def show
  end

  # GET /aviaries/new
  def new
    @aviary = Aviary.new
  end

  # GET /aviaries/1/edit
  def edit
  end

  # POST /aviaries or /aviaries.json
  def create
    @aviary = Aviary.new(aviary_params)

    respond_to do |format|
      if @aviary.save
        format.html { redirect_to @aviary, notice: "Aviary was successfully created." }
        format.json { render :show, status: :created, location: @aviary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @aviary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aviaries/1 or /aviaries/1.json
  def update
    respond_to do |format|
      if @aviary.update(aviary_params)
        format.html { redirect_to @aviary, notice: "Aviary was successfully updated." }
        format.json { render :show, status: :ok, location: @aviary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @aviary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aviaries/1 or /aviaries/1.json
  def destroy
    @aviary.destroy!

    respond_to do |format|
      format.html { redirect_to aviaries_path, status: :see_other, notice: "Aviary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aviary
      @aviary = Aviary.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def aviary_params
      params.expect(aviary: [ :sections, :name, :description ])
    end
end
