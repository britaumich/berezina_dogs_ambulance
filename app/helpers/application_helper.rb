module ApplicationHelper

  def show_date_time(field)
    field.strftime("%m/%d/%Y %I:%M%p") unless field.blank?
  end

  def show_date_with_month_name(field)
    field.to_date.strftime("%B %d, %Y") unless field.blank?
  end

  def show_animal(animal)
    if animal.nickname.present?
      animal.nickname
    else
      animal.id
    end
  end

  def age(animal)
    if animal.birth_year.present?
      dob = animal.birth_year
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
  
  
end
