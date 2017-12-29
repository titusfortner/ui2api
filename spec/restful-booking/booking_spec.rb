RSpec.describe WatirApi do
  describe "Booking" do

    def token
      user = Model::User.authorised
      authenticate = API::Authenticate.create(user)
      JSON.parse(authenticate.body)['token']
    end

    describe "#index" do
      it "returns booking list" do
        bookings = API::Booking.index
        array_of_bookings = JSON.parse bookings.body

        expect(array_of_bookings).to all(be_a Hash)
        expect(array_of_bookings.first).to have_key("bookingid")
      end
    end

    describe "#create" do
      it "adds new booking" do
        booking = API::Booking.create
        id = JSON.parse(booking.body)['bookingid']

        array_of_bookings = JSON.parse API::Booking.index.body
        expect(array_of_bookings.map { |b| b['bookingid'] }).to include(id)
      end
    end

    describe "#show" do
      it "returns values for booking" do
        booking = Model::Booking.new
        create_booking = API::Booking.create(booking)
        id = JSON.parse(create_booking.body)['bookingid']

        booking_response = API::Booking.show(id: id)
        booking_parsed = JSON.parse booking_response.body
        show_booking = Model::Booking.convert(booking_parsed)

        # This is a workaround for an intentional bug in the restful-booker API
        show_booking.bookingdates.checkin = show_booking.bookingdates.checkin + 1
        show_booking.bookingdates.checkout = show_booking.bookingdates.checkout + 1

        expect(booking).to eq show_booking
      end
    end

    # update doesn't seem to work with restful-booking
    describe "#update" do
      xit "returns 200" do
        booking = API::Booking.create(Model::Booking.new)
        id = (JSON.parse booking.body)['bookingid']

        updated_booking = Model::Booking.new
        updated = API::Booking.update(id: id, with: updated_booking, token: token)
        expect(updated.code).to be(200)
      end
    end

    describe "#destroy" do
      it "deletes booking" do
        booking = API::Booking.create
        id = (JSON.parse booking.body)['bookingid']

        API::Booking.destroy(id: id, token: token)

        bookings = JSON.parse API::Booking.index.body
        expect(bookings.map { |b| b['bookingid'] }).to_not include(id)
      end
    end

  end
end
