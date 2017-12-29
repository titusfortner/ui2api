RSpec.describe WatirApi do
  describe "Authorisation" do
    it "returns user data" do
      user = Model::User.authorised.to_api
      authenticate = API::Authenticate.create(user)
      expect(JSON.parse authenticate.body).to have_key('token')
    end
  end
end
