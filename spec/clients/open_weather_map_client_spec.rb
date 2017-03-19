require 'rails_helper'

RSpec.describe OpenWeatherMapClient, vcr: true do
  it 'should return the current conditions' do
    city = 'Dublin, IE'
    response = described_class.new.current_conditions(city: city)
    expect(response[:city]).to eq('Dublin'), 'City returned from API should be the same as requested'
    expect(response[:cloud_cover]).to be_between(0, 100).inclusive, 'Cloud cover should between 0 and 100'
    expect(response[:condition]).to be_a(String), 'Condition should be valid'
    expect(response[:country_code]).to eq('IE'), 'Country code should be IE'
    expect(response[:icon_url]).to match(%r{http://openweathermap.org/img/w/\w+\.png}), 'Icon URL should be valid'
    expect(response[:temp]).to be_between(-30, 50).inclusive, 'Temperature should be valid'
    expect(response[:visibility]).to be_between(0, 100).inclusive, 'Visibility in km should be valid'
    expect(response[:wind_deg]).to be_between(0, 360).inclusive, 'Wind angle should be valid'
    expect(response[:wind_speed]).to be_between(0, 200).inclusive, 'Wind speed should be valid'
  end

  it 'should return the forecast' do
    city = 'Dublin, IE'
    response = described_class.new.forecast(city: city, days: 16)
    expect(response[:city]).to eq('Dublin'), 'City returned from API should be the same as requested'
    expect(response[:country_code]).to eq('IE'), 'Country code should be IE'
    expect(response[:days].count).to eq(16), 'Should return 16 days of data'
    response[:days].each do |day|
      expect(day[:cloud_cover]).to be_between(0, 100).inclusive, 'Cloud cover should between 0 and 100'
      expect(day[:condition]).to be_a(String), 'Condition should be valid'
      expect(day[:date]).to be_a(Date), 'Date should be valid'
      expect(day[:humidity]).to be_between(0, 100).inclusive, 'Humidity should be valid'
      expect(day[:icon_url]).to match(%r{http://openweathermap.org/img/w/\w+\.png}), 'Icon URL should be valid'
      expect(day[:pressure]).to be_between(700, 1300), 'Pressure should be valid'
      expect(day[:rain]).to eq(nil).or(be_between(0, 500).inclusive), 'Rain should be valid if present'
      expect(day[:snow]).to eq(nil).or(be_between(0, 500).inclusive), 'Snow should be valid if present'
      expect(day[:temp_max]).to be_between(-30, 50).inclusive, 'Max temperature should be valid'
      expect(day[:temp_min]).to be_between(-30, 50).inclusive, 'Min temperature should be valid'
      expect(day[:visibility]).to eq(nil).or(be_between(0, 100).inclusive), 'Visibility in km should be valid'
      expect(day[:wind_deg]).to be_between(0, 360).inclusive, 'Wind angle should be valid'
      expect(day[:wind_speed]).to be_between(0, 200).inclusive, 'Wind speed should be valid'
    end
  end

  it 'should raise NotFound if city is invalid' do
    expect { described_class.new.current_conditions(city: '***') }.to raise_error(OpenWeatherMapClient::NotFound)
  end

  it "should raise NetError if there's an unexpected network error" do
    allow(HTTParty).to receive(:get).and_raise(HTTParty::Error)
    expect { described_class.new.current_conditions(city: '***') }.to raise_error(OpenWeatherMapClient::NetError)
  end
end
