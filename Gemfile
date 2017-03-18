source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'                    # Ruby on Rails
gem 'httparty', '~> 0.14.0'                # HTTP client based on Net::HTTP

# Frontend + asset pipeline
gem 'haml', '~> 4.0.7'                     # HTML preprocessor
gem 'sass-rails', '~> 5.0.6'               # CSS preprocessor
gem 'coffee-rails', '~> 4.2.1'             # JS preprocessor
gem 'uglifier', '~> 3.1.4'                 # JS compressor
gem 'jquery-rails', '~> 4.2.1'             # jQuery JS library
gem 'turbolinks', '~> 5'                   # Avoids full page reloads

group :development, :test do
  gem 'awesome_print'                      # Pretty print with colour and indent
  gem 'byebug'                             # Ruby debugger
  gem 'puma'                               # Development web server
  gem 'spring'                             # Rails preloader for development/test
  gem 'spring-watcher-listen'              # Monitor filesystem changes for spring
  gem 'spring-commands-rspec'              # Enable spring for the rspec command
end

group :development do
  gem 'rubocop', '0.47.1', require: false  # Ruby static code analyser
end

group :test do
  gem 'rspec-rails', require: false        # RSpec BDD testing framework
  gem 'simplecov', require: false          # Code coverage analysis
  gem 'vcr', require: false                # Record and replay HTTP requests for testing
  gem 'webmock', require: false            # Stubbing HTTP requests
  gem 'capybara', require: false           # Simulates user interactions for integration tests
  gem 'selenium-webdriver', require: false # Simulates web browser interactions
end
