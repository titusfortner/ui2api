require "bundler/setup"
require "watir_model"
require "watir_api"
require "require_all"

require_rel "support/apis"
require_rel "support/data"

include WatirApi

Base.base_url = "https://restful-booker.herokuapp.com"

RSpec.configure do |config|
  config.include WatirApi
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end