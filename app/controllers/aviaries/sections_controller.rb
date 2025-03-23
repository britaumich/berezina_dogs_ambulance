class Aviaries::SectionsController < ApplicationController
  include ActionView::RecordIdentifier
  include RecordHelper
  before_action :set_aviary
  before_action :set_section, only: %i[ show edit update destroy ]


  # GET /sections or /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1 or /sections/1.json
  def show
    @sections = @aviary.sections
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
        section = Section.new
        @sections = @aviary.sections
        format.turbo_stream {
          render turbo_stream: [ turbo_stream.replace(dom_id_for_records(@aviary, section), partial: 'aviaries/sections/form', locals: { section: section, aviary: @aviary }),
                                turbo_stream.append("#{dom_id(@aviary)}_sections", partial: 'aviaries/sections/sections_list', locals: { aviary: @aviary }) ]
        }
        format.html { redirect_to @aviary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@aviary, @section), partial: 'aviaries/sections/form', locals: { section: @section, aviary: @aviary })
        }
        format.html { redirect_to @aviary }
      end
    end
  end

  # PATCH/PUT /sections/1 or /sections/1.json
  def update
    if @section.update(section_params)
      redirect_to aviary_section_path(@aviary, @section)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sections/1 or /sections/1.json
  def destroy
    if @section.animals.any?
      flash.now[:alert] = t("text.Section has animals and can't be deleted")
      @section = Section.new
      @sections = @aviary.sections
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('flash', partial: 'layouts/notification')
        end
      end
      return
    end
    @section.destroy
    respond_to do |format|
      format.turbo_stream { }
      format.html { redirect_to @section.aviary }
    end
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
