class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[ show edit update upload_pictures destroy ]

  # GET /animals or /animals.json
  def index
    @animals = Animal.all
  end

  # GET /animals/1 or /animals/1.json
  def show
    @medical_procedures = @animal.medical_procedures
  end

  # GET /animals/new
  def new
    @animal_types = AnimalType.all
    @animal = Animal.new
  end

  # GET /animals/1/edit
  def edit
    @animal_types = AnimalType.all
  end

  # POST /animals or /animals.json
  def create
    @animal = Animal.new(animal_params)

    respond_to do |format|
      if @animal.save
        format.html { redirect_to @animal, notice: "Animal was successfully created." }
        format.json { render :show, status: :created, location: @animal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animals/1 or /animals/1.json
  def update
    respond_to do |format|
      if @animal.update(animal_params)
        format.html { redirect_to @animal, notice: "Animal was successfully updated." }
        format.json { render :show, status: :ok, location: @animal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_pictures
    if @animal.update(animal_params)
      render turbo_stream: turbo_stream.update("pictures", partial: "pictures")
    else
      render turbo_stream: turbo_stream.update("image_errors_picture", partial: "picture_errors", locals: { image_field_name: 'pictures' })
    end
  end

  def delete_picture
    delete_file = ActiveStorage::Attachment.find(params[:id])
    delete_file.purge
    redirect_back(fallback_location: request.referer)
  end

  # DELETE /animals/1 or /animals/1.json
  def destroy
    @animal.destroy!

    respond_to do |format|
      format.html { redirect_to animals_path, status: :see_other, notice: "Animal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal
      @animal = Animal.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def animal_params
      params.expect(animal: [ :nickname, :surname, :gender, :arival_date, :from_people, :from_place, :birth_year, :birth_month, 
        :death_date, :color, :aviary, :description, :history, :graduation, :animal_type_id, pictures: [] ])
    end
end
