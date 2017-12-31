require 'spec_helper'

RSpec.describe WatirApi do
  describe "Booking" do

    describe "#index" do
      it "returns bookings as Array of Hashes" do
        bookings = API::Booking.index

        expect(bookings.data).to all(be_a Hash)
        expect(bookings.data.first).to have_key(:bookingid)
      end
    end

    describe "#create" do
      it "adds new booking" do
        booking = API::Booking.create
        id = booking.data[:bookingid]

        bookings = API::Booking.index.data
        expect(bookings.map { |b| b[:bookingid] }).to include(id)
      end

      it "returns booking information as nested Hash" do
        booking = Model::Booking.new
        created_booking = API::Booking.create(booking)

        converted_booking = Model::Booking.convert created_booking.data[:booking]

        expect(converted_booking).to eq booking
      end
    end

    describe "#show" do
      it "returns booking information as a WatirModel" do
        booking = Model::Booking.new
        create_booking = API::Booking.create(booking)
        id = create_booking.data[:bookingid]

        show_booking = API::Booking.show(id: id).booking

        expect(show_booking).to eq booking
      end

      module Model
        class SpecialBooking < Booking
          key(:something_else) { 'Has a Default Value' }
        end
      end

      it "returns special booking information as a hash" do
        allow(API::Booking).to receive(:model_object).and_return(Model::SpecialBooking)

        create_booking = API::Booking.create
        id = create_booking.data[:bookingid]

        show_booking = API::Booking.show(id: id).data

        expect(show_booking).to be_a Hash
      end
    end

    # update doesn't seem to work; I think this is intentional
    describe "#update" do
      it "verifies syntax even if not working" do
        booking = API::Booking.create(Model::Booking.new)
        id = booking.data[:bookingid]

        updated_booking = Model::Booking.new
        API::Booking.update(id: id, with: updated_booking, token: token)

        show_booking = API::Booking.show(id: id).booking
        expect(show_booking).to eq updated_booking
      end
    end

    describe "#destroy" do
      it "deletes booking" do
        id = API::Booking.create.data[:bookingid]

        API::Booking.destroy(id: id, token: token)

        bookings = API::Booking.index.data
        expect(bookings.map { |b| b[:bookingid] }).to_not include(id)
      end
    end
  end

  def token
    user = Model::User.authorised
    API::Authenticate.create(user).token
  end

end
