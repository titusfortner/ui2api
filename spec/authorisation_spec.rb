RSpec.describe WatirApi do
  describe "#authorisation" do

    it "returns authorisation" do
      user = Model::User.new(username: "admin", password: "password123").to_api
      authenticate = API::Authenticate.create(user)
      expect(authenticate).to have_key('token')
    end
  end
end
