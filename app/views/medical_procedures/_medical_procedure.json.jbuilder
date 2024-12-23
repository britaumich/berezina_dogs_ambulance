json.extract! medical_procedure, :id, :date_complete, :complete, :date_planned, :notes, :animal_id, :procedure_type_id, :created_at, :updated_at
json.url medical_procedure_url(medical_procedure, format: :json)
