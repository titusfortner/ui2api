module UI2API
  module API
    class Authenticate < API::Base
      def self.endpoint
        'auth'
      end
    end

    attr_accessor :token

      def initialize(*)
        super
        @token = @data[:token]
      end
  end
end
