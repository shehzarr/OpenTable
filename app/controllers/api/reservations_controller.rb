class Api::ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :update, :destroy]

  def index
    @reservations = Reservation.where(user_id: current_user.id) 
    render :index
  end

  def show
    render :show 
  end

  def create 
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id

    if @reservation.save 
      render :show 
    else
      render json: @reservation.errors.full_messages, status: 422
    end
  end

  def update
    if @reservation.user_id == current_user.id && @reservation.update(reservation_params) 
      render :show
    else
      render json: @reservation.errors.full_messages, status: 422
    end
  end

  def delete 
    if @reservation.user_id == current_user.id
      @reservation.destroy
    else 
      render json: ["You can only cancel your own reservation"], status: 422
    end
  end

  private
  
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:party_size, :status, :date, :time, :special_request, :restaurant_id)
  end

end
