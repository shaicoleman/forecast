# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'awesome_print'
require 'byebug'
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
end
