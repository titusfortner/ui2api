module API
  class Booking < WatirApi::Base
    def self.endpoint
      'booking'
    end

    def self.update(id, payload, token)
      opt = {cookies: {token: token}}
      super(id.to_i, payload, opt)
    end

    def self.destroy(opt)
      opt[:cookies] = {token: opt.delete(:token)}
      super
    end
  end

end