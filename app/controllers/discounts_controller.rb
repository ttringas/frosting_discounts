class DiscountsController < ApplicationController

  respond_to :html, :json, :js

  def create
    Discount.build_new_codes
    redirect_to 'pages#index'
  end

  def update
  end

  def destroy
  end

  def index
    @discounts = Discount.all
    respond_with do |f|
      f.html
      f.json { render json: @discounts }
      f.js  { render json: @discounts, callback: params[:callback] }
    end
  end

end
