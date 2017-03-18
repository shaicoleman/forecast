class ForecastController < ApplicationController
  def index
    @city = params[:city]
    return unless @city.present?
    owm = OpenWeatherMapClient.new
    @current_conditions = owm.current_conditions(city: @city)
  end
end
