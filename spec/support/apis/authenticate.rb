module API
  class Authenticate < WatirApi::Base
    def self.endpoint
      'auth'
    end

    attr_accessor :token
      def initialize(*)
        super
        @token = @data[:token]
      end
  end
end
