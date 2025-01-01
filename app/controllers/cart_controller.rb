class CartController < ApplicationController

  def show
    # @render_cart = false
    @procedures = ProcedureType.all.map { |p| [p.name, p.id] }
    @animal_ids = @cart.cart_animals.pluck(:animal_id)
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
                              turbo_stream.update('cart_total', partial: 'cart/cart_total')]
      end
    end
  end

  def add_medical_procedure
    session[:return_to] = request.referer

    cart = Cart.find(params[:cart_id])
    cart.cart_animals.each do |cart_animal|
      MedicalProcedure.create(date_planned: params[:date_planned], animal_id: cart_animal.animal_id, procedure_type_id: params[:procedure_type_id])
    end
    notice = "Medical order created."
    respond_to do |format|
      cart.destroy
    # flash.now[:notice] = "Medical order creataed."
    # redirect_to request.referrer, notice: "You're being redirected"
    # @procedures = ProcedureType.all.map { |p| [p.name, p.id] }
    # render :show, notice: "Medical order created."
    # redirect_back(fallback_location: request.referer, notice: "Medical order created.")
    # format.html { redirect_to cart_path, notice: notice }
      format.turbo_stream do
        redirect_to cart_path, notice: notice
      end
    end
  end

  private


end
