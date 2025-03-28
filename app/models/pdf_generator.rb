class PdfGenerator
  require 'prawn'
  include ApplicationHelper

  def initialize(animals)
    @animals = animals
  end

  # def self.generate_pdf(content)
  #   Prawn::Document.new do
  #     text "Hello, World!"
  #     text content
  #   end.render
  # end

  def generate_pdf_content
    Prawn::Document.new do |pdf|
      # Register the external font
      pdf.font_families.update('Montserrat' => {
        normal: Rails.root.join('app/assets/stylesheets/Montserrat-Regular.ttf')
      })
      pdf.font('Montserrat') # Use the registered font

      # Add content to the PDF
      @animals.each_with_index do |animal, index|
        pdf.start_new_page unless index == 0
        pdf.text "#{animal.animal_type.name} - #{animal.animal_status.name}", size: 24, align: :center
        pdf.move_down 20
        pdf.text "#{I18n.t('activerecord.attributes.animal.id')}: #{animal.id}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.nickname')}: #{animal.nickname}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.surname')}: #{animal.surname}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.gender')}: #{animal.gender}", size: 12
        pdf.text "#{I18n.t('label.Birth Date')}: #{show_birth_or_death_date(animal, "birth")}", size: 12
        pdf.text "#{I18n.t('label.Age')}: #{age(animal)}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.size')}: #{animal.size}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.color')}: #{animal.color}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.distinctive_feature')}: #{animal.distinctive_feature}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.arival_date')}: #{show_date(animal.arival_date)}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.from_people')}: #{animal.from_people}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.from_place')}: #{animal.from_place}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.sterilization')}: #{animal.sterilization ? 'Yes' : 'No'}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.medical_history')}: #{animal.medical_history}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.aviary_id')}: #{show_aviary(animal)}", size: 12
        pdf.text "#{I18n.t('activerecord.attributes.animal.graduation')}: #{animal.graduation}", size: 12
        pdf.text "#{I18n.t('label.Death Date')}: #{show_birth_or_death_date(animal, "death")}", size: 12

        pdf.move_down 20
        
        table_data = Array.new
        table_data << ["#{I18n.t('activerecord.attributes.medical_procedure.procedure_type_id')}", "#{I18n.t('activerecord.attributes.medical_procedure.date_planned')}", "#{I18n.t('activerecord.attributes.medical_procedure.date_completed')}"]
        animal.medical_procedures.each do |procedure|
          table_data << [procedure.procedure_type.name, show_date(procedure.date_planned), show_date(procedure.date_completed)]
        end
        pdf.table(table_data, header: true, width: 500, cell_style: { inline_format: true, size: 12 })
      end

    end.render
  end
end
