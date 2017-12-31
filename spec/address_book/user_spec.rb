require 'spec_helper'

module UI2API
  RSpec.describe API::User do

    let(:user) { Model::ABUser.new }

    it 'creates and retrieves' do
      created_user = API::User.create(user)
      expect(created_user.remember_token).to_not eq nil

      found_user = API::User.show
      expect(found_user.data[:email]).to eq user.email_address
    end
  end
end
