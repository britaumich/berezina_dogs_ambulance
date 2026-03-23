class Api::AnimalsController < Api::BaseController
  
  def index
    @animals = Animal.includes(:animal_type, :aviary, :animal_status).order(:id)
    authorize @animals
    
    respond_to do |format|
      format.json { 
        render json: @animals.as_json(
          include: [:animal_type, :aviary, :animal_status],
          methods: [:main_picture_url]
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
