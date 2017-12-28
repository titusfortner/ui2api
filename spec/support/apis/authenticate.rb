module API
  class Authenticate < WatirApi::Base
    def self.endpoint
      'auth'
    end

    def self.create(*)
      response = super
      JSON.parse(response.body)
    end
  end
end
