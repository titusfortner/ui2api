RSpec.describe WatirApi do
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
      payload = {firstname: 'Roger',
                 lastname: 'Ramjet',
                 totalprice: 111,
                 depositpaid: true,
                 bookingdates: {checkin: '11-11-2018',
                                 checkout: '12-11-2018'},
                 additionalneeds: 'Breakfast'}.to_json

      booking = API::Booking.create(payload)

      expect(booking.code).to be(200)
    end
  end
end