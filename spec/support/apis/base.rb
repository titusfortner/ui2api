module UI2API
  module API
    class Base < UI2API::Base
      class << self
        def base_url
          if ENV['RUN_LOCAL']
            "http://localhost:3001"
          else
            "https://restful-booker.herokuapp.com"
          end
        end
      end
    end
  end
end
