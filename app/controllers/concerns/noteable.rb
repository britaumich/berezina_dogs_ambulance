module Noteable
  extend ActiveSupport::Concern
  include ActionView::RecordIdentifier
  include RecordHelper

  def create
    @note = @noteable.notes.new(note_params)
    @note.user = current_user
    authorize @note
    respond_to do |format|
      if @note.save
        note = Note.new
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@noteable, note), partial: 'notes/form', locals: { note: note, noteable: @noteable })
        }
        format.html { redirect_to @noteable }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(dom_id_for_records(@noteable, @note), partial: 'notes/form', locals: { note: @note, noteable: @noteable })
        }
        format.html { redirect_to @noteable }
      end
    end
  end

  private

    def note_params
      params.require(:note).permit(:body, :parent_id)
    end
end
