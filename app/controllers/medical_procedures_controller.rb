class MedicalProceduresController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :resume_session
  before_action :set_medical_procedure, only: %i[ show edit update destroy ]

  # GET /medical_procedures or /medical_procedures.json
  def index
    
    @medical_procedures = MedicalProcedure.all.order(:date_planned)
    if params[:q].nil?
      @q = @medical_procedures.ransack(params[:q])
    else
      @q = @medical_procedures.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @date_planned_gteq = params[:q].present? && params[:q][:date_planned_gteq].present? ? params[:q][:date_planned_gteq] : nil
    @date_planned_lteq = params[:q].present? && params[:q][:date_planned_lteq].present? ? params[:q][:date_planned_lteq] : nil
    @date_completed_gteq = params[:q].present? && params[:q][:date_completed_gteq].present? ? params[:q][:date_completed_gteq] : nil
    @date_completed_lteq = params[:q].present? && params[:q][:date_completed_lteq].present? ? params[:q][:date_completed_lteq] : nil

    @medical_procedures = @q.result.includes(:animal).page(params[:page])
    authorize @medical_procedures
  end

  # GET /medical_procedures/1 or /medical_procedures/1.json
  def show
  end

  # GET /medical_procedures/new
  def new
    @medical_procedure = MedicalProcedure.new
    @animal = nil
    @return_to_animal = false
    authorize @medical_procedure
  end

  def new_medical_procedure_for_animal
    @animal = Animal.find(params[:animal_id])
    @medical_procedure = MedicalProcedure.new
    @return_to_animal = true
  end

  # GET /medical_procedures/1/edit
  def edit
    @return_to_animal = false
  end

  def edit_medical_procedure_for_animal
    @medical_procedure = MedicalProcedure.find(params[:procedure_id])
    @return_to_animal = true
  end

  # POST /medical_procedures or /medical_procedures.json
  def create
    @medical_procedure = MedicalProcedure.new(medical_procedure_params)

    respond_to do |format|
      if @medical_procedure.save
        if params[:return_to_animal] == 'true'
          format.html { redirect_to @medical_procedure.animal, notice: t('forms.messages.Medical procedure was successfully created') }
        else
          format.html { redirect_to @medical_procedure, notice: t('forms.messages.Medical procedure was successfully created') }
        end
      else
        @return_to_animal = params[:return_to_animal]
        @animal = @medical_procedure.animal
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medical_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_procedures/1 or /medical_procedures/1.json
  def update
    respond_to do |format|
      if @medical_procedure.update(medical_procedure_params)
        if params[:return_to_animal] == 'true'
          format.html { redirect_to @medical_procedure.animal, notice: t('forms.messages.Medical procedure was successfully updated') }
        else
          format.html { redirect_to @medical_procedure, notice: t('forms.messages.Medical procedure was successfully updated') }
        end
        format.json { render :show, status: :ok, location: @medical_procedure }
      else
        @return_to_animal = params[:return_to_animal]
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medical_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete_procedures
    procedure_ids = params[:medical_procedure_ids].keys.map(&:to_i)
    medical_procedures = MedicalProcedure.where(id: procedure_ids)
    transaction = ActiveRecord::Base.transaction do
      medical_procedures.update_all(date_completed: params[:date_completed])
    end
    if transaction
      flash.now[:notice] = t('forms.messages.Medical procedures were successfully updated')
      @medical_procedures = MedicalProcedure.all.order(:date_planned)
      @q = @medical_procedures.ransack(params[:q])
      @medical_procedures = @q.result.includes(:animal).page(params[:page])
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [ turbo_stream.update("turbo-medical-procedures", partial: 'medical_procedures/procedure_list'),
                                  turbo_stream.update('flash', partial: 'layouts/notification') ]
        end
      end
    else
      flash.now[:alert] = t('forms.messages.Error updating database records')
      @medical_procedures = MedicalProcedure.all.order(:date_planned)
      @q = @medical_procedures.ransack(params[:q])
      @medical_procedures = @q.result.includes(:animal).page(params[:page])
      render :index, status: :unprocessable_entity
    end
  end

  # DELETE /medical_procedures/1 or /medical_procedures/1.json
  def destroy
    @medical_procedure.destroy!

    respond_to do |format|
      if params[:return_to_animal] == 'true'
        format.html { redirect_to @medical_procedure.animal, notice: t('forms.messages.Medical procedure was successfully deleted') }
      else
        format.html { redirect_to medical_procedures_path, status: :see_other, notice: t('forms.messages.Medical procedure was successfully deleted') }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical_procedure
      @medical_procedure = MedicalProcedure.find(params.expect(:id))
      authorize @medical_procedure
    end

    # Only allow a list of trusted parameters through.
    def medical_procedure_params
      params.expect(medical_procedure: [ :date_completed, :complete, :description, :date_planned, :animal_id, :procedure_type_id ])
    end
end
