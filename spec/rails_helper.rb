# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'simplecov'
require 'vcr'

SimpleCov.start do
  add_filter 'spec'
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    serialize_with: :compressed,
    decode_compressed_response: true,
    record: :new_episodes
  }
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
