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

  def medical_calendar
    start_date = params.fetch(:start_date, Date.today).to_date
    @medical_procedures = MedicalProcedure.where("date_planned BETWEEN ? and ? OR date_completed BETWEEN ? and ?", start_date.beginning_of_month.beginning_of_week, start_date.end_of_month.end_of_week, start_date.beginning_of_month.beginning_of_week, start_date.end_of_month.end_of_week).order(:procedure_type_id)
    authorize @medical_procedures
  end

  def day_procedures
    @day = params[:date].to_date
    @day_medical_procedures = MedicalProcedure.where("(date_planned BETWEEN ? AND ?)", @day.beginning_of_day, @day.end_of_day).order(:procedure_type_id)
  end

  # GET /medical_procedures/1 or /medical_procedures/1.json
  def show
  end

  # GET /medical_procedures/new
  def new
    @medical_procedure = MedicalProcedure.new
    @animal = nil
    @return_to_animal = false
    @return_to_calendar = params[:return_to_calendar].present? ? params[:return_to_calendar] : false
    @animal_ids = params[:animal_ids].present? ? params[:animal_ids] : nil
    @date_planned = params[:date_planned].present? ? params[:date_planned].to_date : nil
    authorize @medical_procedure
  end

  def new_medical_procedure_for_animal
    @animal = Animal.find(params[:animal_id])
    @medical_procedure = MedicalProcedure.new
    @return_to_animal = true
  end

  # GET /medical_procedures/1/edit
  def edit
    @animal = @medical_procedure.animal
    @return_to_animal = false
    @date_planned = @medical_procedure.date_planned
  end

  def edit_medical_procedure_for_animal
    @medical_procedure = MedicalProcedure.find(params[:procedure_id])
    @return_to_animal = true
  end

  # POST /medical_procedures or /medical_procedures.json
  def create

    animal_ids = params[:animal_ids]
    transaction = ActiveRecord::Base.transaction do
      animal_ids.each do |animal_id|
        @medical_procedure = MedicalProcedure.new(medical_procedure_params)
        @medical_procedure.animal_id = animal_id
        raise ActiveRecord::Rollback unless @medical_procedure.save
        true
      end
    end

    if transaction
      if params[:return_to_animal] == 'true'
        redirect_to @medical_procedure.animal, notice: t('forms.messages.Medical procedure was successfully created')
      elsif params[:return_to_calendar] == 'true'
        redirect_to medical_calendar_path, notice: t('forms.messages.Medical procedure was successfully created')
      elsif animal_ids.size == 1 && params[:return_to_animal] == 'false'
        redirect_to @medical_procedure, notice: t('forms.messages.Medical procedure was successfully created')
      else
        redirect_to medical_procedures_path, notice: t('forms.messages.Medical procedure was successfully created')
      end
    else
      @medical_procedure = MedicalProcedure.new
      @return_to_animal = params[:return_to_animal]
      flash.now[:alert] = t('forms.messages.Error creating medical procedure')
      render :new, status: :unprocessable_entity
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
      if params[:day].present?
        @day = params[:day].to_date
        @day_medical_procedures = MedicalProcedure.where("(date_planned BETWEEN ? AND ?)", @day.beginning_of_day, @day.end_of_day).order(:procedure_type_id)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [ turbo_stream.update("turbo-medical-procedures", partial: 'medical_procedures/day_procedures_list'),
                                    turbo_stream.update('flash', partial: 'layouts/notification') ]
          end
        end
      else
        @medical_procedures = MedicalProcedure.all.order(:date_planned)
        @q = @medical_procedures.ransack(params[:q])
        @medical_procedures = @q.result.includes(:animal).page(params[:page])
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [ turbo_stream.update("turbo-medical-procedures", partial: 'medical_procedures/procedure_list'),
                                    turbo_stream.update('flash', partial: 'layouts/notification') ]
          end
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

  def sort_animals
    @sort_by = params[:sort_by]
    @animals = Animal.order(@sort_by)
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
