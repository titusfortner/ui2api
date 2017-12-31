require "bundler/setup"
require "watir_model"
require "ui2api"
require "require_all"

require_rel "support/apis"
require_rel "support/data"
require_rel "support/site"

include UI2API

WatirModel.yml_directory = "spec/support/config/data"

RSpec.configure do |config|
  config.include UI2API
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
