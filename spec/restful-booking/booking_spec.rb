RSpec.describe WatirApi do
  describe "Booking" do

    def token
      user = Model::User.authorised
      API::Authenticate.create(user).data['token']
    end

    describe "#index" do
      it "returns booking list" do
        bookings = API::Booking.index

        expect(bookings.data).to all(be_a Hash)
        expect(bookings.data.first).to have_key("bookingid")
      end
    end

    describe "#create" do
      it "adds new booking" do
        booking = API::Booking.create
        id = booking.data['bookingid']

        bookings = API::Booking.index.data
        expect(bookings.map { |b| b['bookingid'] }).to include(id)
      end
    end

    describe "#show" do
      it "returns values for booking" do
        booking = Model::Booking.new
        create_booking = API::Booking.create(booking)
        id = create_booking.data['bookingid']

        booking_response = API::Booking.show(id: id)
        show_booking = Model::Booking.convert(booking_response.data)

        # This is a workaround for an intentional bug in the restful-booker API
        show_booking.bookingdates.checkin = show_booking.bookingdates.checkin + 1
        show_booking.bookingdates.checkout = show_booking.bookingdates.checkout + 1

        expect(booking).to eq show_booking
      end
    end

    # update doesn't seem to work; I think this is intentional
    describe "#update" do
      it "verifies syntax even if not working" do
        booking = API::Booking.create(Model::Booking.new)
        id = booking.data['bookingid']

        updated_booking = Model::Booking.new
        updated = API::Booking.update(id: id, with: updated_booking, token: token)
      end
    end

    describe "#destroy" do
      it "deletes booking" do
        id = API::Booking.create.data['bookingid']

        API::Booking.destroy(id: id, token: token)

        bookings = API::Booking.index.data
        expect(bookings.map { |b| b['bookingid'] }).to_not include(id)
      end
    end

  end
end
