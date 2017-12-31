module WatirApi
  module API
    class ABBase < WatirApi::Base
      class << self
        def headers
          opt = super

          return opt if ABSite.user.nil?

          opt[:cookies] = {remember_token: ABSite.user.remember_token}
          opt
        end

        def base_url
          if ENV['RUN_LOCAL']
            "http://localhost:3000"
          else
            "https://address-book-example.herokuapp.com"
          end
        end
      end
    end
  end
end
