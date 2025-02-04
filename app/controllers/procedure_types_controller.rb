class ProcedureTypesController < ApplicationController
  before_action :set_procedure_type, only: %i[ edit update destroy ]

  # GET /procedure_types or /procedure_types.json
  def index
    @procedure_types = ProcedureType.all
  end

  # GET /procedure_types/new
  def new
    @procedure_type = ProcedureType.new
  end

  # GET /procedure_types/1/edit
  def edit
  end

  # POST /procedure_types or /procedure_types.json
  def create
    @procedure_type = ProcedureType.new(procedure_type_params)

    respond_to do |format|
      if @procedure_type.save
        format.html { redirect_to procedure_types_url, notice: t('forms.messages.Procedure type was successfully created') }
        format.json { render :show, status: :created, location: @procedure_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @procedure_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /procedure_types/1 or /procedure_types/1.json
  def update
    respond_to do |format|
      if @procedure_type.update(procedure_type_params)
        format.html { redirect_to procedure_types_url, notice: t('forms.messages.Procedure type was successfully updated') }
        format.json { render :show, status: :ok, location: @procedure_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @procedure_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procedure_types/1 or /procedure_types/1.json
  def destroy
    @procedure_type.destroy!

    respond_to do |format|
      format.html { redirect_to procedure_types_path, status: :see_other, notice: t('forms.messages.Procedure type was successfully deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_procedure_type
      @procedure_type = ProcedureType.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def procedure_type_params
      params.expect(procedure_type: [ :name, :description ])
    end
end
