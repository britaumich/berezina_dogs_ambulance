class Api::AnimalsController < Api::BaseController
  
  def index
    @animal_type_id = params[:animal_type_id].present? ? params[:animal_type_id] : AnimalType.find_by(name: 'собака').id
    @animals = Animal.where(animal_type_id: @animal_type_id).order(:id)
    
    # Handle filtering and searching
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
    
    # Handle date filters
    @arival_date_lteq = params[:q].present? && params[:q][:arival_date_lteq].present? ? params[:q][:arival_date_lteq] : nil
    @arival_date_gteq = params[:q].present? && params[:q][:arival_date_gteq].present? ? params[:q][:arival_date_gteq] : nil
    
    # Handle sorting
    if params[:sort].present?
      @sort_by = params[:sort]
      @order = params[:order].presence || 'asc'
      @q.sorts = "#{@sort_by} #{@order}"
    end
    
    @animals = @q.result.includes(:animal_type, :aviary, :animal_status)
    authorize @animals
    
    respond_to do |format|
      format.json { 
        render json: @animals.as_json(
          include: [:animal_type, :aviary, :animal_status]
        )
      }
      format.csv { 
        send_data @animals.to_csv, 
                  charset: "utf-8", 
                  filename: "animals-#{Date.current.strftime('%Y%m%d')}.csv",
                  type: 'text/csv'
      }
    end
  end
end
