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
  
end
