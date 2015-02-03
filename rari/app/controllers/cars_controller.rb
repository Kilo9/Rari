class CarsController < ApplicationController
  require 'will_paginate'

  before_action :set_car, only: [:show, :edit, :update, :destroy]

  # GET /cars
  # GET /cars.json
  def index
    @cars = Car.all

    if params[:query]
      @cars = @cars.where("LOWER(model) LIKE ? OR price LIKE ? OR year LIKE ?", "%" + params[:query].downcase + "%", "%" + params[:query].downcase + "%", "%" + params[:query].downcase + "%")
    end

    #filtering
    case params[:filter]
    when 'az'
      @cars = @cars.order(:model)
    when 'za'
      @cars = @cars.order(:model).reverse_order
    when 'old'
      @cars = @cars.order(:year)
    when 'new'
      @cars = @cars.order(:year).reverse_order
    when 'low'
      @cars = @cars.order(:price)
    when 'high'
      @cars = @cars.order(:price).reverse_order
    end

    @cars = @cars.paginate(:page => params[:page], :per_page => 4)
  end

  # GET /cars/1
  # GET /cars/1.json
  def show
  end

  # GET /cars/new
  def new
    @car = Car.new
    
    unless logged_in?
      redirect_to :back, notice: 'Please sign up to list a car!'
    end
  end

  # GET /cars/1/edit
  def edit 
    unless logged_in? && @car.user_id == current_user.id
      redirect_to request.env['HTTP_REFERER'] || root_url , notice: 'You can only edit your own listings!'
    end
  end

  # POST /cars
  # POST /cars.json
  def create
    @car = Car.new(car_params)
    @car.user_id = current_user.id

    @car.image = upload 

    respond_to do |format|
      if @car.save
        format.html { redirect_to @car, notice: 'Car was successfully created.' }
        format.json { render :show, status: :created, location: @car }
      else
        format.html { render :new }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cars/1
  # PATCH/PUT /cars/1.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to @car, notice: 'Car was successfully updated.' }
        format.json { render :show, status: :ok, location: @car }
      else
        format.html { render :edit }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cars/1
  # DELETE /cars/1.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url, notice: 'Car was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:model, :year, :price, :desc, :image)
    end

    def upload
      uploaded_io = params[:car][:image]
      File.open(Rails.root.join('app', 'assets', 'images', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      return uploaded_io.original_filename
    end
end
