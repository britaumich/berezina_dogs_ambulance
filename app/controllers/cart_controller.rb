class CartController < ApplicationController
  def show
    # @render_cart = false
    @procedures = ProcedureType.all.map { |p| [ p.name, p.id ] }
    @animal_ids = @cart.cart_animals.pluck(:animal_id)
    @sections = []
    authorize @cart

    if params[:format] == 'csv' || params[:format] == 'pdf'
      animals = @cart.cart_animals
      export_animals = Animal.where(id: animals.map(&:animal_id))
      respond_to do |format|
        format.csv { send_data export_animals.to_csv, charset: "utf-8", filename: "#{t('menu.header.animals')}-#{show_date(Time.zone.today)}.csv" }
        format.pdf { send_data PdfGenerator.new(export_animals).generate_pdf_content, filename: "#{t('menu.header.animals')}-#{show_date(Time.zone.today)}.pdf", type: 'application/pdf', disposition: 'inline'}
      end
    end
  end

  def add
    animal_ids = params[:animal_ids].keys.map(&:to_i)
    cart_ids = @cart.cart_animals.pluck(:animal_id)
    new_ids = animal_ids - cart_ids
    authorize @cart
    new_ids.each do |animal_id|
      @cart.cart_animals.create!(animal: Animal.find(animal_id))
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('cart_total', partial: 'cart/cart_total')
      end
      format.html { redirect_to request.referer, notice: t('forms.messages.The cart has been updated with new records') }
    end
  end

  def remove
    CartAnimal.find_by(id: params[:id]).destroy
    @animal_ids = @cart.cart_animals.pluck(:animal_id)
    @procedures = ProcedureType.all.map { |p| [ p.name, p.id ] }
    authorize @cart
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ turbo_stream.replace('cart', partial: 'cart/cart', locals: { cart: @cart }),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.update('procedure_ids', partial: 'cart/order_medical'),
                              turbo_stream.update('add_to_enclosure', partial: 'cart/add_to_enclosure') ]
      end
    end
  end

  def empty_cart 
    @cart = Cart.find(params[:id])
    @cart.cart_animals.destroy_all
    @procedures = ProcedureType.all.map { |p| [ p.name, p.id ] }
    authorize @cart
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ turbo_stream.replace('cart', partial: 'cart/cart', locals: { cart: @cart }),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.update('procedure_ids', partial: 'cart/order_medical'),
                              turbo_stream.update('add_to_enclosure', partial: 'cart/add_to_enclosure') ]
      end
    end
  end

  def add_medical_procedure
    authorize @cart
    cart = Cart.find(params[:cart_id])
    cart.cart_animals.each do |cart_animal|
      MedicalProcedure.create(date_planned: params[:date_planned], animal_id: cart_animal.animal_id, procedure_type_id: params[:procedure_type_id])
    end
    cart.destroy
    flash.now[:notice] = t('forms.messages.Medical procedures created')
    @procedures = ProcedureType.all.map { |p| [ p.name, p.id ] }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ turbo_stream.replace('cart',
                                                  partial: 'cart/cart',
                                                 ),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.replace('procedure_ids', partial: 'cart/order_medical'),
                              turbo_stream.update('flash', partial: 'layouts/notification')
                            ]
      end
    end
  end

  def add_completed_medical_procedure
    authorize @cart
    cart = Cart.find(params[:cart_id])
    cart.cart_animals.each do |cart_animal|
      MedicalProcedure.create(date_completed: params[:date_completed], animal_id: cart_animal.animal_id, procedure_type_id: params[:procedure_type_id])
    end
    cart.destroy
    flash.now[:notice] = t('forms.messages.Medical procedures created')
    @procedures = ProcedureType.all.map { |p| [ p.name, p.id ] }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ turbo_stream.replace('cart',
                                                  partial: 'cart/cart',
                                                 ),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.replace('procedure_ids', partial: 'cart/order_medical'),
                              turbo_stream.update('flash', partial: 'layouts/notification')
                            ]
      end
    end
  end

  def add_to_aviary
    authorize @cart
    cart = Cart.find(params[:cart_id])
    cart.cart_animals.each do |cart_animal|
      Animal.find(cart_animal.animal_id).update(aviary_id: params[:aviary_id], section_id: params[:section_id])
    end
    cart.destroy
    flash.now[:notice] = t('forms.messages.Added to enclosure')
    @sections = []
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ turbo_stream.replace('cart',
                                                  partial: 'cart/cart',
                                                 ),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.replace('add_to_enclosure', partial: 'cart/add_to_enclosure'),
                              turbo_stream.update('flash', partial: 'layouts/notification')
                            ]
      end
    end
  end

  def export_from_cart
    fail
  end

  private
end
