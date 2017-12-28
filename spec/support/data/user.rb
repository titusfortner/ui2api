require 'faker'

module WatirApi
  module Data
    class User < WatirModel

      key(:email_address) { Faker::Internet.email }
      key(:password) { Faker::Internet.password }

    end
  end
end
