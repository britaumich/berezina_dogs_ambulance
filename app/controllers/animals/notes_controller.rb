class Animals::NotesController < ApplicationController
  include Noteable

  before_action :set_noteable

  private

    def set_noteable
      @noteable = Animal.find(params[:animal_id])
    end
end
