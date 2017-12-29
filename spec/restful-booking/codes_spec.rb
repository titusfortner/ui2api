RSpec.describe WatirApi do
  describe "#route" do
    it "makes use of endpoint" do
      expect(API::Booking.route).to eq "#{Base.base_url}/booking"
    end
  end

  describe "#index" do
    it "returns 200" do
      bookings = API::Booking.index

      expect(bookings.code).to be(200)
    end
  end

  describe "#show" do
    it "returns 200" do
      booking = API::Booking.show(id: 1)

      expect(booking.code).to be(200)
    end

    it "returns 418 with bad header" do
      booking = API::Booking.show(id: 1, accept: :text)

      expect(booking.code).to be(418)
    end
  end

  describe "#create" do
    it "returns 200" do
      booking = API::Booking.create(Model::Booking.new)

      expect(booking.code).to be(200)
    end
  end

  # update doesn't seem to work
  describe "#update" do
    xit "returns 200" do
      booking = API::Booking.create(Model::Booking.new)
      id = (JSON.parse booking.body)['bookingid']

      user = Model::User.authorised
      authenticate = API::Authenticate.create(user)
      token = JSON.parse(authenticate.body)['token']

      updated_booking = Model::Booking.new
      updated = API::Booking.update(id: id, with: updated_booking, token: token)
      expect(updated.code).to be(200)
    end
  end

  describe "#destroy" do
    it "returns 200" do
      booking = API::Booking.create(Model::Booking.new)
      id = (JSON.parse booking.body)['bookingid']

      user = Model::User.authorised
      authenticate = API::Authenticate.create(user)
      token = JSON.parse(authenticate.body)['token']

      deletion = API::Booking.destroy(id: id, token: token)
      expect(deletion.code).to be(201)
      expect(API::Booking.show(id: id).code).to eq 404
    end
  end
end