module API
  class Booking < WatirApi::Base
    class << self
      def endpoint
        'booking'
      end

      def update(id:, with:, **opt)
        opt[:cookies] = {token: opt.delete(:token)}
        super
      end

      def destroy(opt)
        opt[:cookies] = {token: opt.delete(:token)}
        super
      end

      def model_object
        Model::Booking
      end
    end
  end
end
