class AnimalStatusesController < ApplicationController
  before_action :set_animal_status, only: %i[ edit update destroy ]

  # GET /animal_statuses or /animal_statuses.json
  def index
    @animal_statuses = AnimalStatus.all.order(:name)
  end

  # GET /animal_statuses/new
  def new
    @animal_status = AnimalStatus.new
  end

  # GET /animal_statuses/1/edit
  def edit
  end

  # POST /animal_statuses or /animal_statuses.json
  def create
    @animal_status = AnimalStatus.new(animal_status_params)

    respond_to do |format|
      if @animal_status.save
        format.html { redirect_to animal_statuses_url, notice: t('forms.messages.Animal status was successfully created') }
        format.json { render :show, status: :created, location: @animal_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @animal_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animal_statuses/1 or /animal_statuses/1.json
  def update
    respond_to do |format|
      if @animal_status.update(animal_status_params)
        format.html { redirect_to animal_statuses_url, notice: t('forms.messages.Animal status was successfully updated') }

        format.json { render :show, status: :ok, location: @animal_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @animal_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_statuses/1 or /animal_statuses/1.json
  def destroy
    @animal_status.destroy!

    respond_to do |format|
      format.html { redirect_to animal_statuses_path, status: :see_other, notice: "Animal status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal_status
      @animal_status = AnimalStatus.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def animal_status_params
      params.expect(animal_status: [ :name ])
    end
end
