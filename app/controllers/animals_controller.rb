class AnimalsController < ApplicationController
  include ApplicationHelper
  allow_unauthenticated_access only: [ :index, :show ]
  before_action :resume_session
  before_action :set_animal, only: %i[ show duplicate edit update upload_pictures destroy delete_medical_procedure ]

  # GET /animals or /animals.json
  def index
    
    @animal_type_id = params[:animal_type_id].present? ? params[:animal_type_id] : AnimalType.find_by(name: 'собака').id
    @animals = Animal.where(animal_type_id: @animal_type_id).order(:id)
    if params[:switch_view] == 'table'
      @view = 'table'
    elsif params[:switch_view] == 'pictures'
      @view = 'pictures'
    else
      @view = 'table'
    end
    if params[:sort].present?
      @sort_by = params[:sort]
      @order = params[:order]
    else
      @sort_by = nil
    end
    if params[:q].nil?
      @q = @animals.ransack(params[:q])
      @status_id = nil
    else
      if params[:q][:animal_status_name_eq].present?
        @status_id = AnimalStatus.find_by(name: params[:q][:animal_status_name_eq]).id
      end
      if params[:q][:sterilization_eq].present? && params[:q][:sterilization_eq] == '0'
        params[:q] = params[:q].except('sterilization_eq')
      end
      @q = @animals.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @arival_date_lteq = params[:q].present? && params[:q][:arival_date_lteq].present? ? params[:q][:arival_date_lteq] : nil
    @arival_date_gteq = params[:q].present? && params[:q][:arival_date_gteq].present? ? params[:q][:arival_date_gteq] : nil
    if @sort_by.present?
      @q.sorts = @sort_by + ' ' + @order
    end
    @animals = @q.result.includes(:animal_type, :aviary, :animal_status).page(params[:page])
    authorize @animals

    if params[:format] == 'csv'
      respond_to do |format|
        format.csv { send_data @animals.to_csv, filename: "#{t('menu.header.citizens')}-#{show_date(Time.zone.today)}.csv" }
      end
    end
  end

  def duplicate
    @duplicate_animal_id = @animal.id
    @animal = @animal.dup
    render :new
  end

  # GET /animals/1 or /animals/1.json
  def show
    @medical_procedures = @animal.medical_procedures

    respond_to do |format|
      format.html { render :show, status: :ok }
      format.pdf do
        pdf_content = generate_pdf_content(@animal)
        send_data pdf_content, filename: "animal_#{@animal.id}.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  # GET /animals/new
  def new
    @animal = Animal.new
    @birth_year = 0
    @birth_month = 14
    @birth_day = 32
    @death_year = 0
    @death_month = 14
    @death_day = 32
    authorize @animal
  end

  # GET /animals/1/edit
  def edit
    if @animal.aviary&.has_sections
      @sections = Section.where(aviary_id: @animal.aviary_id).order(:name)
      @section_id = @animal.section_id
    end
    @birth_year = @animal.birth_year.present? ? @animal.birth_year.year : 0
    @birth_month = @animal.birth_day.present? ? @animal.birth_day.month : 14
    @birth_day = @animal.birth_day.present? ? @animal.birth_day.day : 32
    @death_year = @animal.death_year.present? ? @animal.death_year.year : 0
    @death_month = @animal.death_day.present? ? @animal.death_day.month : 14
    @death_day = @animal.death_day.present? ? @animal.death_day.day : 32
  end

  # POST /animals or /animals.json
  def create
    @animal = Animal.new(animal_params)
    if params['birth_year'].present?
      @animal.birth_year = Date.new(params['birth_year'].to_i)
    end
    if params['birth']['birth_month'].present? && params['birth']['birth_day'].present?
      @animal.birth_day = Date.new(0, params['birth']['birth_month'].to_i, params['birth']['birth_day'].to_i)
    end

    if params['death_year'].present?
      @animal.death_year = Date.new(params['death_year'].to_i)
    end
    if params['death']['death_month'].present? && params['death']['death_day'].present?
      @animal.death_day = Date.new(0, params['death']['death_month'].to_i, params['death']['death_day'].to_i)
    end

    respond_to do |format|
      if @animal.save
        if params['sibling_id'].present?
          family = Family.new(@animal)
          family.add_sibling(params['sibling_id'])
        end
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
    family = Family.new(@animal)
    family.update_real_parent(animal_params[:parent_id])
    @animal.attributes = animal_params
    if params['birth_year'].present?
      @animal.birth_year = Date.new(params['birth_year'].to_i)
    else
      @animal.birth_year = nil
    end
    if params['birth']['birth_month'].present? && params['birth']['birth_day'].present?
      @animal.birth_day = Date.new(0, params['birth']['birth_month'].to_i, params['birth']['birth_day'].to_i)
    else
      @animal.birth_day = nil
    end

    if params['death_year'].present?
      @animal.death_year = Date.new(params['death_year'].to_i)
    else
      @animal.death_year = nil
    end
    if params['death']['death_month'].present? && params['death']['death_day'].present?
      @animal.death_day = Date.new(0, params['death']['death_month'].to_i, params['death']['death_day'].to_i)
    else
      @animal.death_day = nil
    end

    if params['sibling_remove'].present?
      family = Family.new(@animal)
      family.remove_sibling(params['sibling_remove'].keys)
    end

    respond_to do |format|
      if @animal.update(animal_params)
        if params['sibling_id'].present?
          family = Family.new(@animal)
          family.add_sibling(params['sibling_id'])
        end
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
        render turbo_stream: [ turbo_stream.replace('procedures', partial: 'animals/animal_medicine'),
                              turbo_stream.update('flash', partial: 'layouts/notification') ]
      end
    end
  end

  def upload_pictures
    if @animal.update(animal_params)
      render turbo_stream: turbo_stream.update('pictures', partial: 'pictures')
    else
      render turbo_stream: turbo_stream.update('image_errors_picture', partial: 'picture_errors', locals: { image_field_name: 'pictures' })
    end
  end

  def delete_picture
    delete_file = ActiveStorage::Attachment.find(params[:id])
    authorize Animal
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
      authorize @animal
    end

    # Only allow a list of trusted parameters through.
    def animal_params
      params.expect(animal: [ :nickname, :surname, :sterilization, :gender, :size, :arival_date, :from_people, :from_place, :birth_year, :birth_day,
        :death_year, :death_day, :color, :aviary_id, :section_id, :distinctive_feature, :medical_history, :graduation, :animal_type_id, :animal_status_id, :parent_id, :fake_parent_id, pictures: [] ])
    end

    def generate_pdf_content(animal)
      Prawn::Document.new do |pdf|
        # Register the external font
        pdf.font_families.update('Montserrat' => {
          normal: Rails.root.join('app/assets/stylesheets/Montserrat-Regular.ttf')
        })
        pdf.font('Montserrat') # Use the registered font

        # Add content to the PDF
        pdf.text "#{animal.animal_type.name} - #{animal.animal_status.name}", size: 24, align: :center
        pdf.move_down 20
        pdf.text "#{t('activerecord.attributes.animal.id')}: #{animal.id}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.nickname')}: #{animal.nickname}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.surname')}: #{animal.surname}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.gender')}: #{animal.gender}", size: 12
        pdf.text "#{t('label.Birth Date')}: #{show_birth_or_death_date(animal, "birth")}", size: 12
        pdf.text "#{t('label.Age')}: #{age(animal)}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.size')}: #{animal.size}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.color')}: #{animal.color}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.distinctive_feature')}: #{animal.distinctive_feature}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.arival_date')}: #{show_date(animal.arival_date)}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.from_people')}: #{animal.from_people}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.from_place')}: #{animal.from_place}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.sterilization')}: #{animal.sterilization ? 'Yes' : 'No'}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.medical_history')}: #{animal.medical_history}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.aviary_id')}: #{show_aviary(animal)}", size: 12
        pdf.text "#{t('activerecord.attributes.animal.graduation')}: #{animal.graduation}", size: 12
        pdf.text "#{t('label.Death Date')}: #{show_birth_or_death_date(animal, "death")}", size: 12

        pdf.move_down 20
        
        table_data = Array.new
        table_data << ["#{t('activerecord.attributes.medical_procedure.procedure_type_id')}", "#{t('activerecord.attributes.medical_procedure.date_planned')}", "#{t('activerecord.attributes.medical_procedure.date_completed')}"]
        animal.medical_procedures.each do |procedure|
          table_data << [procedure.procedure_type.name, show_date(procedure.date_planned), show_date(procedure.date_completed)]
        end
        pdf.table(table_data, header: true, width: 500, cell_style: { inline_format: true, size: 12 })


      end.render
    end
end
