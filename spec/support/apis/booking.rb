module API
  class Booking < WatirApi::Base
    def self.endpoint
      'booking'
    end

    def self.update(id:, with:, **opt)
      opt[:cookies] = {token: opt.delete(:token)}
      super
    end

    def self.destroy(opt)
      opt[:cookies] = {token: opt.delete(:token)}
      super
    end
  end

end