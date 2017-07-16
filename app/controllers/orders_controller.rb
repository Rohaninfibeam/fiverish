class OrdersController < ApplicationController
  before_action :authenticate_user!

  def create
    @service = Service.find(params[:order][:service_id])
    total_price = params[:order][:quantity].to_i*@service.price.to_i
    @order = current_user.orders.new(orders_params.merge({"total_price"=>total_price,"price"=>@service.price}))
    if(!@order.save)
      render 'services/#{@service.id}/show'
    else
      render 'payment'
    end
  end

  def payment
  end

  def create_payment
    @order = Order.find(params[:order_id])
    stripe_card_id = CreditCardService.new(current_user.id, card_params).create_credit_card
    @stripe = Stripe::Charge.create(
      customer: current_user.customer_id,
      source:   stripe_card_id,
      amount:   @order.total_price*100,
      currency: 'INR'
    )
    flash[:success] = "Payment successfull"
    redirect_to :controller=> 'services', :action=>'index'
  rescue Stripe::CardError, Stripe::InvalidRequestError => e
    flash[:error] = e.message
    render "payment"
  end

  def user_orders
    @orders = current_user.orders
  end

  private
    def orders_params
      params.require(:order).permit(:service_id,:price,:quantity)
    end

    def card_params
      params.require(:credit_card).permit(:number,:month,:year,:cvc)
    end
end
