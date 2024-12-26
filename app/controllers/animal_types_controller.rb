class AnimalTypesController < ApplicationController
  before_action :set_animal_type, only: %i[ show edit update destroy ]

  # GET /animal_types or /animal_types.json
  def index
    @animal_types = AnimalType.all
  end

  # GET /animal_types/1 or /animal_types/1.json
  def show
  end

  # GET /animal_types/new
  def new
    @animal_type = AnimalType.new
  end

  # GET /animal_types/1/edit
  def edit
  end

  # POST /animal_types or /animal_types.json
  def create
    @animal_type = AnimalType.new(animal_type_params)

    respond_to do |format|
      if @animal_type.save
        format.html { redirect_to animal_types_url, notice: "Animal type was successfully created." }
        format.json { render :show, status: :created, location: @animal_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @animal_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animal_types/1 or /animal_types/1.json
  def update
    respond_to do |format|
      if @animal_type.update(animal_type_params)
        format.html { redirect_to animal_types_url, notice: "Animal type was successfully updated." }
        format.json { render :show, status: :ok, location: @animal_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_types/1 or /animal_types/1.json
  def destroy
    @animal_type.destroy!

    respond_to do |format|
      format.html { redirect_to animal_types_path, status: :see_other, notice: "Animal type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_type
      @animal_type = AnimalType.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def animal_type_params
      params.expect(animal_type: [ :name ])
    end
end
