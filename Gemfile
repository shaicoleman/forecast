source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.5.0'

gem 'rails', '~> 5.2.0'                    # Ruby on Rails

# Backend gems
gem 'bootsnap', '~> 1.3.0', require: false # Reduces boot times through caching
gem 'httparty', '~> 0.16.2'                # HTTP client based on Net::HTTP

# Frontend + asset pipeline
gem 'coffee-rails', '~> 4.2.2'             # JS preprocessor
gem 'haml', '~> 5.0.4'                     # HTML preprocessor
gem 'jquery-rails', '~> 4.3.3'             # jQuery JS library
gem 'sass-rails', '~> 5.0.7'               # CSS preprocessor
gem 'uglifier', '~> 4.1.11'                # JS compressor

gem 'rails-assets-bulma', '~> 0.7.1',         source: 'https://rails-assets.org' # CSS framework
gem 'rails-assets-font-awesome', '~> 4.3.0',  source: 'https://rails-assets.org' # Icon set font
gem 'rails-assets-lightslider', '~> 1.1.6',   source: 'https://rails-assets.org' # JQuery Slider

group :development, :test do
  gem 'awesome_print'                      # Pretty print with colour and indent
  gem 'byebug'                             # Ruby debugger
  gem 'puma'                               # Development web server
  gem 'spring'                             # Rails preloader for development/test
  gem 'spring-commands-rspec'              # Enable spring for the rspec command
  gem 'spring-watcher-listen'              # Monitor filesystem changes for spring
end

group :development do
  gem 'rubocop', '0.57.2', require: false  # Ruby static code analyser
end

group :test do
  gem 'capybara', '~> 3.1.1', require: false  # Simulates user interactions for integration tests
  # gem 'chromedriver-helper', require: false # chromedriver system tests
  gem 'rspec-rails', require: false         # RSpec BDD testing framework with Rails support
  gem 'rspec_junit_formatter', require: false # RSpec formatter for CircleCI
  gem 'selenium-webdriver', require: false  # Simulates web browser interactions
  gem 'simplecov', require: false           # Code coverage analysis
  gem 'vcr', require: false                 # Record and replay HTTP requests for testing
  gem 'webmock', require: false             # Stubbing HTTP requests
end
