class AnimalsController < ApplicationController
  before_action :set_animal, only: %i[ show edit update upload_pictures destroy delete_medical_procedure ]

  # GET /animals or /animals.json
  def index
    if params[:switch_view] == "table"
      @view = "table"
    elsif params[:switch_view] == "pictures"
      @view = "pictures"
    else 
      @view = "table"
    end
    if params[:sort].present?
      @sort_by = params[:sort]
      @order = params[:order]
    else
      @sort_by = nil
    end
    if params[:status_id].present?
      @status_id = params[:status_id].to_i
    else 
      @status_id = 1
    end
    if @status_id == 0
      @animals = Animal.all.order(:id)
    else
      @animals = Animal.where(animal_status_id: @status_id).order(:id)
    end
    if params[:q].nil?
      @q = @animals.ransack(params[:q])
    else
      if params[:q][:sterilization_eq].present? && params[:q][:sterilization_eq] == "0"
        params[:q] = params[:q].except("sterilization_eq")
      end
      @q = @animals.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    if @sort_by.present?
      @q.sorts = @sort_by + ' ' + @order
    end
    @animals = @q.result.includes(:animal_type, :aviary).page(params[:page])
  end

  # GET /animals/1 or /animals/1.json
  def show
    @medical_procedures = @animal.medical_procedures
  end

  # GET /animals/new
  def new
    @animal = Animal.new
  end

  # GET /animals/1/edit
  def edit
    if @animal.aviary&.has_sections
      @sections = Section.where(aviary_id: @animal.aviary_id).order(:name)
      @section_id = @animal.section_id
    end
  end

  # POST /animals or /animals.json
  def create
    @animal = Animal.new(animal_params)
    if params['birth_year'].present?
      @animal.birth_year = Date.new(params['birth_year'].to_i)
    end
    if params['birth'].present?
      @animal.birth_day = Date.new(0, params['birth']['birth_month'].to_i, params['birth']['birth_day'].to_i)
    end

    respond_to do |format|
      if @animal.save
        format.html { redirect_to @animal, notice: t('forms.messages.Animal was successfully created') }
        format.json { render :show, status: :created, location: @animal }
      else
        @section_id = animal_params[:section_id]
        @sections = Section.where(aviary_id: @animal.aviary_id).order(:name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animals/1 or /animals/1.json
  def update
    @animal.attributes = animal_params
    if params['birth_year'].present?
      @animal.birth_year = Date.new(params['birth_year'].to_i)
    end
    if params['birth'].present?
      @animal.birth_day = Date.new(0, params['birth']['birth_month'].to_i, params['birth']['birth_day'].to_i)
    end
    if animal_params[:section_id].present?
      @section_id = animal_params[:section_id]
    end
    respond_to do |format|
      if @animal.update(animal_params)
        format.html { redirect_to @animal, notice: t('forms.messages.Animal was successfully updated') }
        format.json { render :show, status: :ok, location: @animal }
      else
        @section_id = animal_params[:section_id]
        @sections = Section.where(aviary_id: @animal.aviary_id).order(:name)
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete_medical_procedure
    procedure = MedicalProcedure.find(params[:procedure_id]).destroy
    @medical_procedures = @animal.medical_procedures
    flash.now[:notice] = t('forms.messages.Medical procedure was successfully deleted')
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.replace('procedures', partial: 'animals/animal_medicine'),
                              turbo_stream.update('flash', partial: 'layouts/notification')]
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
      format.html { redirect_to animals_path, status: :see_other, notice: t('forms.messages.Animal was successfully deleted') }
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
      params.expect(animal: [ :nickname, :surname, :sterilization, :gender, :arival_date, :from_people, :from_place, :birth_year, :birth_day, 
        :death_year, :death_day, :color, :aviary_id, :section_id, :description, :history, :graduation, :animal_type_id, :animal_status_id, :parent_id, pictures: [] ])
    end
end
