module WatirApi
  module Model
    class User < Base
      key(:username) { Faker::Internet.user_name }
      key(:password) { Faker::Internet.password }
    end
  end
end
