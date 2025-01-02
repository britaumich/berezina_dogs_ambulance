class Aviaries::SectionsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_aviary
  before_action :set_section, only: %i[ show edit update destroy cancel_reason]


  # GET /sections or /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1 or /sections/1.json
  def show
    @sessions = @aviary.sessions
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections or /sections.json
  def create
    @section = @aviary.sections.new(section_params)

    respond_to do |format|
      if @section.save
        @aviary.update(has_sections: true)
        
        format.turbo_stream do
          @new_section = Section.new
          notice = "Section was created."
          flash.now[:notice] = notice
        end
        format.html { redirect_to aviary_section_path(@aviary), notice: notice }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to @section, notice: "Section was successfully updated." }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel_reason
  end
  # DELETE /sections/1 or /sections/1.json
  def destroy
    @section.destroy!
    @sections = @aviary.sections
    respond_to do |format|
      format.html { redirect_to aviary_path(@aviary), notice: notice }
      # format.turbo_stream do
      #   render turbo_stream: [turbo_stream.replace('sections_list',
      #                                             partial: 'aviaries/sections/sections_list", sections: @aviary.sections',
      #                                            ),
      #                         turbo_stream.update('flash', partial: 'layouts/notification')
      #                       ]
      # end
    end


    flash.now[:notice] = "Common attribute was successfully deleted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params.expect(:id))
    end

    def set_aviary
      @aviary = Aviary.find(params[:aviary_id])
    end

    # Only allow a list of trusted parameters through.
    def section_params
      params.expect(section: [ :name, :description, :aviary_id ])
    end
end
