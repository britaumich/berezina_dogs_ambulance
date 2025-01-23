class CartController < ApplicationController

  def show
    # @render_cart = false
    @procedures = ProcedureType.all.map { |p| [p.name, p.id] }
    @animal_ids = @cart.cart_animals.pluck(:animal_id)
    @aviaries = Aviary.all.map { |a| [a.name, a.id] }
    @sections = []
  end

  def add
    animal_ids = params[:animal_ids].keys
    animal_ids.each do |animal_id|
      @cart.cart_animals.create!(animal: Animal.find(animal_id))
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('cart_total', partial: 'cart/cart_total')
      end
      format.html { redirect_to request.referrer, notice: "The cart has been updated" }
    end
  end

  def remove
    CartAnimal.find_by(id: params[:id]).destroy
    @animal_ids = @cart.cart_animals.pluck(:animal_id)
    @procedures = ProcedureType.all.map { |p| [p.name, p.id] }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.replace('cart',
                                                  partial: 'cart/cart',
                                                  locals: { cart: @cart }),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.update('procedure_ids', partial: 'cart/order_medical')]
      end
    end
  end

  def add_medical_procedure
    cart = Cart.find(params[:cart_id])
    cart.cart_animals.each do |cart_animal|
      MedicalProcedure.create(date_planned: params[:date_planned], animal_id: cart_animal.animal_id, procedure_type_id: params[:procedure_type_id])
    end
    cart.destroy
    flash.now[:notice] = t('text.Medical procedures created')
    @procedures = ProcedureType.all.map { |p| [p.name, p.id] }
 
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.replace('cart',
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
    cart = Cart.find(params[:cart_id])
    cart.cart_animals.each do |cart_animal|
      Animal.find(cart_animal.animal_id).update(aviary_id: params[:aviary_id], section_id: params[:section_id])
    end
    cart.destroy
    flash.now[:notice] = t('text.added to enclosure')
    @aviaries = Aviary.all.map { |a| [a.name, a.id] }
    @sections = []
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [turbo_stream.replace('cart',
                                                  partial: 'cart/cart',
                                                 ),
                              turbo_stream.update('cart_total', partial: 'cart/cart_total'),
                              turbo_stream.replace('add_to_enclosure', partial: 'cart/add_to_enclosure'),
                              turbo_stream.update('flash', partial: 'layouts/notification')
                            ]
      end
    end
  end

  private


end
