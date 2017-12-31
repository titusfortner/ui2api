module WatirApi
  module API
    class Booking < API::Base
      class << self
        def endpoint
          'booking'
        end

        def update(id:, with:, **opt)
          opt[:cookies] = {token: token}
          super
        end

        def destroy(opt)
          opt[:cookies] = {token: token}
          super
        end

        private

        def token
          user = Model::User.authorised
          API::Authenticate.create(user).data[:token]
        end
      end

      def initialize(*)
        super
        return unless @data.is_a?(Hash) && @booking.nil?

        @id = @data[:bookingid]
        @booking = convert_to_model(@data[:booking])

        singleton_class.class_eval { attr_accessor :id }
        singleton_class.class_eval { attr_accessor :booking }
      end
    end
  end
end
