module ApplicationHelper
  include ActionView::Helpers::TagHelper

  def show_date_time(field)
    field.strftime("%m/%d/%Y %I:%M%p") unless field.blank?
  end

  def show_date_with_month_name(field)
    l field.to_date, format: "%d %B, %Y" unless field.blank?
  end

  def show_date(date)
    if date.present?
      l date
    else
      ""
    end
  end

  def show_animal(animal)
    if animal.nickname.present? || animal.surname.present?
      animal.nickname + " " + animal.surname
    else
      animal.id
    end
  end

  def age(animal)
    if animal.birth_date.present?
      dob = animal.birth_date
      now = Date.today
      months = (now.year * 12 + now.month) - (dob.year * 12 + dob.month)

      # months / 12 will give the number of years
      # months % 12 will give the number of months
      readable_age(months / 12, months % 12)
    else
      "N/A"
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
      aviary += ", #{t('activerecord.attributes.animal.section')} " + animal.section.name
    end
    return aviary
  end

  def gender_lists 
    I18n.t(:gender_lists).map { |key, value| [ value, key ] } 
  end

  def render_flash_stream
    turbo_stream.update "flash", partial: "layouts/notification"
  end

  def show_boolean(var)
    if var
      tags = html_escape('') # initialize an html safe string we can append to
      tags << content_tag(:i, nil, class: "fa-solid fa-check")
      tags
    else
      ""
    end
  end

end
