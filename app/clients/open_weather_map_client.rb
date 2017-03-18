# OpenWeather client
# API documentation: https://openweathermap.org/api
class OpenWeatherMapClient
  class Error < StandardError; end
  class NetError < Error; end
  class NotFound < Error; end

  attr_reader :api_key

  def initialize(api_key: Rails.application.secrets.openweather_api_key)
    @api_key = api_key
  end

  # https://openweathermap.org/current
  # Example: OpenWeatherClient.new.current(city: 'Dublin, IE')
  # Will only return the primary weather condition
  def current(city:)
    result = api_call(path: '/data/2.5/weather', query: { q: city, units: 'metric' })
    city = result['name']
    country_code = result.dig('sys', 'country')
    icon_url = icon_url(icon_id: result.dig('weather', 0, 'icon'))
    condition = result.dig('weather', 0, 'description').titleize
    wind_speed = result.dig('wind', 'speed')
    wind_deg = result.dig('wind', 'deg')
    cloud_cover = result.dig('clouds', 'all')
    visibility = result['visibility']
    { city: city, country_code: country_code, icon_url: icon_url, condition: condition,
      wind_speed: wind_speed, wind_deg: wind_deg, cloud_cover: cloud_cover, visibility: visibility }
  end

  # https://openweathermap.org/forecast16
  # Example: OpenWeatherClient.new.forecast(city: 'Dublin, IE')
  # Dates returned assume a UTC timezone
  def forecast(city:, days: 3)
    result = api_call(path: '/data/2.5/forecast/daily', query: { q: city, cnt: days, units: 'metric' })
    city = result.dig('city', 'name')
    country_code = result.dig('city', 'country')
    days = result['list'].map.with_index do |day, i|
      { date: i.days.from_now.utc.to_date, wind_speed: day['speed'], wind_deg: day['deg'],
        cloud_cover: day['clouds'], pressure: day['pressure'], humidity: day['humidity'],
        rain: day['rain'].to_f, temp_min: day.dig('temp', 'min'), temp_max: day.dig('temp', 'max') }
    end
    { city: city, country_code: country_code, days: days }
  end

  private

  # Handle OpenWeatherMap JSON API calls
  # HTTPS endpoint is not available with the free API
  def api_call(path:, query:)
    url = "http://api.openweathermap.org#{path}"
    query[:appid] = @api_key
    json = get_json(url: url, query: query)
    raise Error, 'Invalid API response' unless json['cod'].present?
    raise NotFound, json['message'] if json['cod'].to_i == 404
    raise Error, json['message'] if json['cod'].to_i != 200
    json
  end

  # Fetch URL and parse it as JSON
  def get_json(url:, query:)
    response = HTTParty.get(url, query: query, format: :json, timeout: 5)
    response.parsed_response
  rescue HTTParty::Error => e
    raise NetError, e.message
  rescue JSON::ParserError, TypeError
    raise ParseError, e.message
  end

  def icon_url(icon_id:)
    "http://openweathermap.org/img/w/#{icon_id}.png"
  end
end
