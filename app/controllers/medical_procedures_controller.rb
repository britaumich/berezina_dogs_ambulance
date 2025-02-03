class MedicalProceduresController < ApplicationController
  before_action :set_medical_procedure, only: %i[ show edit update destroy ]

  # GET /medical_procedures or /medical_procedures.json
  def index
    session[:return_to] = request.referer
    @medical_procedures = MedicalProcedure.all
    if params[:q].nil?
      @q = @medical_procedures.ransack(params[:q])
    else
      @q = @medical_procedures.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @medical_procedures = @q.result.includes(:animal).page(params[:page])
  end

  # GET /medical_procedures/1 or /medical_procedures/1.json
  def show
  end

  # GET /medical_procedures/new
  def new
    @medical_procedure = MedicalProcedure.new
  end

  def new_medical_procedure_for_animal
    @animal = Animal.find(params[:animal_id])
    @medical_procedure = MedicalProcedure.new
  end

  # GET /medical_procedures/1/edit
  def edit
  end

  def edit_medical_procedure_for_animal
    @medical_procedure = MedicalProcedure.find(params[:procedure_id])
  end

  # POST /medical_procedures or /medical_procedures.json
  def create
    @medical_procedure = MedicalProcedure.new(medical_procedure_params)
    
    respond_to do |format|
      if @medical_procedure.save
        if params[:return_to_animal] == "true"
          format.html { redirect_to @medical_procedure.animal, notice: t('forms.messages.Medical procedure was successfully created') }
        else
          format.html { redirect_to @medical_procedure, notice: t('forms.messages.Medical procedure was successfully created') }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @medical_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_procedures/1 or /medical_procedures/1.json
  def update
    respond_to do |format|
      if @medical_procedure.update(medical_procedure_params)
        if params[:return_to_animal] == "true"
          format.html { redirect_to @medical_procedure.animal, notice: t('forms.messages.Medical procedure was successfully updated') }
        else
          format.html { redirect_to @medical_procedure, notice: t('forms.messages.Medical procedure was successfully updated') }
        end
        format.json { render :show, status: :ok, location: @medical_procedure }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @medical_procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_procedures/1 or /medical_procedures/1.json
  def destroy
    @medical_procedure.destroy!

    respond_to do |format|
      if params[:return_to_animal] == "true"
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
    end

    # Only allow a list of trusted parameters through.
    def medical_procedure_params
      params.expect(medical_procedure: [ :date_completed, :complete, :description, :date_planned, :animal_id, :procedure_type_id ])
    end
end
