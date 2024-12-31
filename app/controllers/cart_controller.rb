class CartController < ApplicationController
  before_action :set_render_cart
  before_action :initialize_cart

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
  end

  def remove
    CartAnimal.find_by(id: params[:id]).destroy
    @animal_ids = @cart.cart_animals.pluck(:animal_id)
    @procedures = ProcedureType.all.map { |p| [p.name, p.id] }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('cart',
                                                  partial: 'cart/cart',
                                                  locals: { cart: @cart })
      end
    end
  end

  private

  def set_render_cart
    @render_cart = true
  end

  def initialize_cart
    @cart ||= Cart.find_by(id: session[:cart_id])

    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

end
