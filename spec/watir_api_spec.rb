RSpec.describe WatirApi do
  describe "#create" do
    it "puts data into Application via API" do
      user = API::User.create(WatirApi::Data::User.new)
      user = API::User.show(WatirApi::Data::User.new)

    end
  end

  describe "#index" do
  end

  describe "#show" do
  end

  describe "#update" do
  end

  describe "#destroy" do
  end

end
