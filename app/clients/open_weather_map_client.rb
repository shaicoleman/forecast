# OpenWeatherMap client
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
  # Example: OpenWeatherClient.new.current_conditions(city: 'Dublin, IE')
  # Will only return the primary weather condition
  def current_conditions(city:)
    result = api_call(path: '/data/2.5/weather', query: { q: city, units: 'metric' })
    { city:         result['name'],
      cloud_cover:  result.dig('clouds', 'all'),
      condition:    result.dig('weather', 0, 'description').titleize,
      country_code: result.dig('sys', 'country'),
      icon_url:     icon_url(icon_id: result.dig('weather', 0, 'icon')),
      temp:         result.dig('main', 'temp'),
      visibility:  (result['visibility'] / 1000.0 if result['visibility']),
      wind_deg:     result.dig('wind', 'deg'),
      wind_speed:   wind_speed_in_kmh(result.dig('wind', 'speed')) }
  end

  # https://openweathermap.org/forecast16
  # Example: OpenWeatherClient.new.forecast(city: 'Dublin, IE')
  # Dates returned assume a UTC timezone
  def forecast(city:, days: 3)
    result = api_call(path: '/data/2.5/forecast/daily', query: { q: city, cnt: days, units: 'metric' })
    days = result['list'].map.with_index do |day, i|
      { cloud_cover: day['clouds'],
        condition:   day.dig('weather', 0, 'description').titleize,
        date:        i.days.from_now.utc.to_date,
        humidity:    day['humidity'],
        icon_url:    icon_url(icon_id: day.dig('weather', 0, 'icon')),
        pressure:    day['pressure'],
        rain:        day['rain'].to_f,
        temp_max:    day.dig('temp', 'max'),
        temp_min:    day.dig('temp', 'min'),
        wind_deg:    day['deg'],
        wind_speed:  wind_speed_in_kmh(day['speed']) }
    end
    { city: result.dig('city', 'name'),
      country_code: result.dig('city', 'country'),
      days: days }
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
  rescue HTTParty::Error, Timeout::Error => e
    raise NetError, e.message
  rescue JSON::ParserError, TypeError
    raise ParseError, e.message
  end

  def icon_url(icon_id:)
    "http://openweathermap.org/img/w/#{icon_id}.png"
  end

  def wind_speed_in_kmh(meters_per_sec)
    meters_per_sec * 3.6
  end
end
