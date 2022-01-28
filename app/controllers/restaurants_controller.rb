class RestaurantsController < ApplicationController
  # uncomment to enable: pundit will not take effect for the specified controller method
  # skip_before_action :authenticate_user!, only: [ :show ]

  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
    # policy_scope calls Scope::resolve inside restaurant_policy, it is the way how pundit is written
    @restaurants = policy_scope(Restaurant).order(created_at: :desc)
  end

  # GET /restaurants/1
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
    # pundit: looks into the restaurant_policy.rb and looks for `new?`
    authorize @restaurant
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  def create
    @restaurant = Restaurant.new(restaurant_params)
    # added manually not by scaffold
    @restaurant.user = current_user

    # pundit: looks into the restaurant_policy.rb and looks for `create?`
    authorize @restaurant
    if @restaurant.save
      redirect_to @restaurant, notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /restaurants/1
  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant, notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
      authorize @restaurant
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      # this is because scaffold doesn't know that user_id will be handled with devise
      # params.require(:restaurant).permit(:name, :user_id)
      # modified value
      params.require(:restaurant).permit(:name)
    end
end
