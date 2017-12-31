module WatirApi
  module API
    class Address < API::ABBase
      class << self
        def endpoint
          'addresses'
        end
      end
    end
  end
end
