require 'spec_helper'

RSpec.describe WatirApi do
  describe "Authorisation" do
    it "returns user data" do
      user = Model::User.authorised
      authenticate = API::Authenticate.create(user)
      expect(authenticate.data).to have_key(:token)
    end
  end
end
