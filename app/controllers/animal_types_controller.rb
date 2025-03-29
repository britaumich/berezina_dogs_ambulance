class AnimalTypesController < ApplicationController
  before_action :set_animal_type, only: %i[ edit update destroy ]

  # GET /animal_types or /animal_types.json
  def index
    @animal_types = AnimalType.order(:name)
    authorize @animal_types
  end

  # GET /animal_types/new
  def new
    @animal_type = AnimalType.new
    authorize @animal_type
  end

  # GET /animal_types/1/edit
  def edit
  end

  # POST /animal_types or /animal_types.json
  def create
    @animal_type = AnimalType.new(animal_type_params)

    respond_to do |format|
      if @animal_type.save
        format.html { redirect_to animal_types_url, notice: t('forms.messages.Animal type was successfully created') }
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
        format.html { redirect_to animal_types_url, notice: t('forms.messages.Animal type was successfully updated') }
        format.json { render :show, status: :ok, location: @animal_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_types/1 or /animal_types/1.json
  def destroy
    if @animal_type.animals.any?
      flash.now[:alert] = t("text.There are animals with this type and it can't be deleted")
      @animal_typees = AnimalType.order(:name)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('flash', partial: 'layouts/notification')
        end
      end
      return
    end

    @animal_type.destroy!
    flash.now[:notice] = t('forms.messages.Animal type was successfully deleted')
    @animal_types = AnimalType.order(:name)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ turbo_stream.replace('animal_types', partial: 'animal_types/type_list'),
                                turbo_stream.update('flash', partial: 'layouts/notification') ]
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_type
      @animal_type = AnimalType.find(params.expect(:id))
      authorize @animal_type
    end

    # Only allow a list of trusted parameters through.
    def animal_type_params
      params.expect(animal_type: [ :name, :plural_name ])
    end
end
