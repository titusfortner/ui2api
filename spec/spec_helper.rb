require "watir"
require "watir_model"
require "require_all"
require 'webdrivers'
require "watir_api"

require_rel "support/apis"
require_rel "support/data"
require_rel "support/site"

include WatirApi

Site.base_url = 'http://localhost:3000'

RSpec.configure do |config|
  config.before(:each) do
    @browser =  Watir::Browser.new
    Site.browser = @browser
  end

  config.after(:each) do
    @browser.quit
  end
end
