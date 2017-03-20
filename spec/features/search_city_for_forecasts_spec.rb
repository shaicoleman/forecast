require 'rails_helper'

RSpec.feature 'SearchCityForForecasts', type: :feature, vcr: true do
  it 'shows an error when city is empty' do
    visit '/'
    click_button 'Search'
    expect(page).to have_text('Please fill in the city')
  end

  it 'shows an error when city is invalid' do
    visit '/'
    fill_in 'city', with: 'zzzzz'
    click_button 'Search'
    expect(page).to have_text('Not found city').or(have_text('city not found'))
  end

  it 'shows results when city is valid' do
    visit '/'
    fill_in 'city', with: 'Dublin, Ireland'
    click_button 'Search'
    expect(page).to have_text('°')
    expect(page).to have_text('Dublin, IE')
    expect(page).to have_text(/Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday/)
  end
end
