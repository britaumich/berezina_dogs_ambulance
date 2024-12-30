class MedicalProcedures::NotesController < ApplicationController
  include Noteable

  before_action :set_noteable

  private

    def set_noteable
      @noteable = MedicalProcedure.find(params[:medical_procedure_id])
    end
end
