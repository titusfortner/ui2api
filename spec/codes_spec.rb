RSpec.describe WatirApi do
  describe "#route" do
    it "makes use of endpoint" do
      expect(API::Booking.route).to eq "#{Base.base_url}/booking"
    end

  end


  describe "#index" do
    it "gets code" do
      bookings = API::Booking.index

      expect(bookings.code).to be(200)
    end
  end

  describe "#show" do
    it "gets code" do
      booking = API::Booking.show(1)

      expect(booking.code).to be(200)
    end
  end

  describe "#create" do
    it "gets code" do
      booking = API::Booking.create(Model::Booking.new.to_api)

      expect(booking.code).to be(200)
    end
  end

  describe "#destroy" do
    it "gets code" do
      booking = API::Booking.create(Model::Booking.new.to_api)
      id = (JSON.parse booking.body)['bookingid']

      user = Model::User.authorised.to_api
      authenticate = API::Authenticate.create(user)
      token = JSON.parse(authenticate.body)['token']

      deletion = API::Booking.destroy(id, token)
      expect(deletion.code).to be(201)
    end
  end
end