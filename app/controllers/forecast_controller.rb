class ForecastController < ApplicationController
  def index
    @city = params[:city]
    @input_error = @city&.blank?
    return if @city.blank?
    owm = OpenWeatherMapClient.new
    @current = owm.current_conditions(city: @city)
    @forecast = owm.forecast(city: @city, days: 16)
  rescue OpenWeatherMapClient::Error => e
    @error = e.message
  end
end
