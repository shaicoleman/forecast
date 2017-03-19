class ForecastController < ApplicationController
  def index
    @city = params[:city]
    return unless @city.present?
    owm = OpenWeatherMapClient.new
    @current = owm.current_conditions(city: @city)
    @forecast = owm.forecast(city: @city, days: 16)
  rescue OpenWeatherMapClient::Error => e
  end
end
