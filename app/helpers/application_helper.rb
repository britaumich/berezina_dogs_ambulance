module ApplicationHelper
  include ActionView::Helpers::TagHelper

  def show_date_time(field)
    field.strftime('%m/%d/%Y %I:%M%p') if field.present?
  end

  def show_date_with_month_name(field)
    l field.to_date, format: '%d %B, %Y' if field.present?
  end

  def show_date(date)
    if date.present?
      I18n.l(date)
    else
      ''
    end
  end

  def show_birth_or_death_date(animal, type)
    if type == 'birth'
      return '' if animal.birth_year.blank?
      year = animal.birth_year
      if animal.birth_day.present?
        day = animal.birth_day
        "#{day.day}-#{day.month}-#{year.year}"
      else
        year.year
      end
    elsif type == 'death'
      return '' if animal.death_year.blank?
      year = animal.death_year
      if animal.death_day.present?
        day = animal.death_day
        "#{day.day}-#{day.month}-#{year.year}"
      else
        year.year
      end
    end
  end

  def show_vaccination_date(animal)
  end

  def show_animal(animal)
    if animal.nickname.present? || animal.surname.present?
      animal.nickname + ' ' + animal.surname
    else
      animal.id
    end
  end

  def age(animal)
    return 'N/A' if animal.birth_year.blank?
    now = Time.zone.today
    year = animal.birth_year.year
    month = animal.birth_day.present? ? animal.birth_day.month : 1

    months = (now.year * 12 + now.month) - (year * 12 + month)

      # months / 12 will give the number of years
      # months % 12 will give the number of months
      readable_age(months / 12, months % 12)

  end

  # def age(animal)
  #   return 'N/A' if animal.birth_year.blank?
  #   now = Time.zone.today
  #   year = animal.birth_year.year
  #   month = animal.birth_day.present? ? animal.birth_day.month : 1
  #   day = animal.birth_day.present? ? animal.birth_day.day : 1
  #   now.year - year - ((now.month > month || (now.month == month && now.day >= day)) ? 0 : 1)
  # end

  def readable_age(years, months)
    # for under 1 year olds
    if years == 0
      return months > 1 ? months.to_s + " " + I18n.t('age.months old') : " " + months.to_s + " " + I18n.t('age.month old')  
  
    # for 1 year olds
    elsif years == 1
      return months > 1 ? years.to_s + " " + I18n.t('age.year') + " " + months.to_s + " " + I18n.t('age.months old') : years.to_s + " " + I18n.t('age.year') + months.to_s + " " + I18n.t('age.month old') 
  
    # for older than 1
    else
      return months > 1 ? years.to_s + " " + I18n.t('age.years') + " " + months.to_s + " " + I18n.t('age.months old') : years.to_s + " " + I18n.t('age.years') + months.to_s + " " + I18n.t('age.month old')
    end
  end

  # def readable_age(years, months)
  #   year_text = ''
  #   if years != 0
  #     year_text = "#{pluralize(years, 'year')} "
  #   end

  #   "#{year_text}#{pluralize(months, 'month')}"
  # end

  def show_aviary(animal)
    aviary = ''
    if animal.aviary&.name.present?
      aviary += animal.aviary.name
    end
    if animal.section&.name.present?
      aviary += ", #{I18n.t('text.section')} " + animal.section.name
    end
    aviary
  end

  def gender_lists
    I18n.t(:gender_lists).map { |key, value| [ value, key ] }
  end

  def size_list
    I18n.t(:size_list).map { |key, value| [ value, key ] }
  end

  def render_flash_stream
    turbo_stream.update 'flash', partial: 'layouts/notification'
  end

  def show_boolean(var)
    if var
      tags = html_escape('') # initialize an html safe string we can append to
      tags << content_tag(:i, nil, class: 'fa-solid fa-check')
      tags
    else
      ''
    end
  end

  def fields_to_sort_animals
    [
      [ I18n.t('activerecord.attributes.animal.id'), 'id' ],
      [ I18n.t('activerecord.attributes.animal.nickname'), 'nickname' ],
      [ I18n.t('activerecord.attributes.animal.surname'), 'surname' ],
      [ I18n.t('activerecord.attributes.animal.gender'), 'gender' ],
      [ I18n.t('activerecord.attributes.animal.sterilization'), 'sterilization' ],
      [ I18n.t('activerecord.attributes.animal.aviary_id'), 'aviary_name' ],
      [ I18n.t('activerecord.attributes.animal.arival_date'), 'arival_date' ]
    ]
  end

  def sorting_order
    [
      [ I18n.t('forms.sort.asc'), 'asc' ],
      [ I18n.t('forms.sort.desc'), 'desc' ]
    ]
  end

  def index_views
    [
      [ I18n.t('text.table'), 'table' ],
      [ I18n.t('text.pictures'), 'pictures' ]
    ]
  end

  def animal_types
    AnimalType.order(:name)
  end

  def animal_statuses
    AnimalStatus.order(:name)
  end

  # def animal_statuses_for_select
  #   AnimalStatus.order(:name).map { |status| [ status.name, status.id ] } << [ 'все граждане', 0 ]
  # end

  def aviaries
    Aviary.order(:name)
  end

  def aviaries_for_select
    Aviary.all.map { |a| [ a.name, a.id ] }
  end

  def sections
    []
  end

  def animals
    Animal.order(:nickname)
  end

  def procedure_types
    ProcedureType.order(:name)
  end

  def show_status(status_id, animal_type_id)
    status = AnimalType.find(animal_type_id).plural_name
    if status_id.nil?
      status += ' (все граждане)'
    else
      status += ' (' + AnimalStatus.find(status_id.to_i).name + ')'
    end
  end

  def parents(animal)
    if animal.persisted?
      parents = Animal.shelter.where.not(id: animal.id).sort_by(&:nickname)
    else
      parents = Animal.shelter.sort_by(&:nickname)
    end
    if animal.siblings.present?
      parents -= animal.siblings.to_a
    end
    parents.map { |a| [ a.display_name, a.id ] }
  end

  def possible_siblings(animal)
    siblings = Animal.shelter.order(:nickname)
    if animal.persisted?
      siblings -= [ animal ]
    end
    if animal.parent.present?
      # Exclude the animal's parent
      siblings -= [ animal.parent ]
      # Exclude animals that have real or fake parents (different parents)
      siblings.each do |sibling|
        if sibling.parent_id.present? || sibling.fake_parent_id.present?
          siblings -= [ sibling ]
        end
      end
    end
    siblings.map { |a| [ a.display_name, a.id ] }
  end

  def updated_on_and_by(resource)
    return I18n.t('text.Updated on') + resource.updated_at.strftime(" %m/%d/%Y - %I:%M%p")
  end

  def animal_types_except_dogs
    AnimalType.where.not(name: 'собака').order(:name)
  end

  def show_day_procedure(procedure_id, medical_procedure)
    procedure = ProcedureType.find(procedure_id)
    count = medical_procedure.count
    if count > 1
      procedure.name + " - " + Animal.find(medical_procedure[0].animal_id).nickname + " и еще " + (count - 1).to_s
    else
      procedure.name + " - " + Animal.find(medical_procedure[0].animal_id).nickname
    end
  end
end
