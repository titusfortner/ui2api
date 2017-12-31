module UI2API
  module Model
    class ABUser < Model::Base

      key(:email_address, api: :email) { Faker::Internet.email }
      key(:password) { Faker::Internet.password }
          
    end
  end
end
