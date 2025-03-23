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

  def show_animal(animal)
    if animal.nickname.present? || animal.surname.present?
      animal.nickname + ' ' + animal.surname
    else
      animal.id
    end
  end

  def age(animal)
    if animal.birth_year.present?
      dob = animal.birth_year
      now = Time.zone.today
      months = (now.year * 12 + now.month) - (dob.year * 12 + dob.month)

      # months / 12 will give the number of years
      # months % 12 will give the number of months
      readable_age(months / 12, months % 12)
    else
      'N/A'
    end
  end

  def readable_age(years, months)
    year_text = ''
    if years != 0
      year_text = "#{pluralize(years, 'year')} "
    end

    "#{year_text}#{pluralize(months, 'month')}"
  end

  def show_aviary(animal)
    aviary = ''
    if animal.aviary&.name.present?
      aviary += animal.aviary.name
    end
    if animal.section&.name.present?
      aviary += ", #{t('text.section')} " + animal.section.name
    end
    aviary
  end

  def gender_lists
    I18n.t(:gender_lists).map { |key, value| [ value, key ] }
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
      [ t('activerecord.attributes.animal.id'), 'id' ],
      [ t('activerecord.attributes.animal.animal_type_id'), 'animal_type_name' ],
      [ t('activerecord.attributes.animal.nickname'), 'nickname' ],
      [ t('activerecord.attributes.animal.surname'), 'surname' ],
      [ t('activerecord.attributes.animal.gender'), 'gender' ],
      [ t('activerecord.attributes.animal.sterilization'), 'sterilization' ],
      [ t('activerecord.attributes.animal.aviary_id'), 'aviary_name' ],
      [ t('activerecord.attributes.animal.arival_date'), 'arival_date' ]
    ]
  end

  def sorting_order
    [
      [ t('forms.sort.asc'), 'asc' ],
      [ t('forms.sort.desc'), 'desc' ]
    ]
  end

  def index_views
    [
      [ t('text.table'), 'table' ],
      [ t('text.pictures'), 'pictures' ]
    ]
  end

  def animal_types
    AnimalType.order(:name)
  end

  def animal_statuses
    AnimalStatus.order(:name)
  end

  def animal_statuses_for_select
    AnimalStatus.order(:name).map { |status| [ status.name, status.id ] } << [ 'все граждане', 0 ]
  end

  def aviaries
    Aviary.order(:name)
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

  def show_status(status_id)
    if status_id == 0
      t('label.status') + ' - все граждане'
    else
      t('label.status') + ' - ' + AnimalStatus.find(status_id.to_i).name
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
    return t('text.Updated on') + resource.updated_at.strftime(" %m/%d/%Y - %I:%M%p")
  end
end
