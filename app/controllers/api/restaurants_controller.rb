class Api::RestaurantsController < ApplicationController
  def index
    if params[:filters]
      if params[:filters][:bounds] 
        @restaurants = Restaurant.in_bounds(params[:filters][:bounds])
      elsif params[:filters][:city] 
        @restaurants = params[:filters][:city] == ["All"] ? 
          Restaurant.includes(:reviews).all : Restaurant.includes(:reviews).where(city: params[:filters][:city])
      else 
        @restaurants = Restaurant.includes(:reviews).all
      end
      
      @restaurants = @restaurants.where(:price_range => params[:filters][:price]) if params[:filters][:price]
      @restaurants = @restaurants.where(:cuisines => params[:filters][:cuisines]) if params[:filters][:cuisines]
      @restaurants = @restaurants.where("ratings >= ?", params[:filters][:rating]) if params[:filters][:rating]
      
    else
      @restaurants = Restaurant.includes(:reviews).all
    end

    render :index
  end

  def show 
    @restaurant = Restaurant.find(params[:id])
    render :show
  end


end
