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
end
