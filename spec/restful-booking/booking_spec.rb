require 'spec_helper'

RSpec.describe UI2API do
  describe "Booking" do

    describe "#index" do
      it "returns bookings as Array of Hashes" do
        bookings = API::Booking.index

        expect(bookings.data).to all have_key(:bookingid)
      end
    end

    describe "#create" do
      it "adds new booking" do
        id = API::Booking.create.id

        booking_ids = API::Booking.index.data
        expect(booking_ids.map { |b| b[:bookingid] }).to include(id)
      end

      it "returns booking information as nested Hash" do
        booking = Model::Booking.new
        created_booking = API::Booking.create(booking).booking

        expect(created_booking).to eq booking
      end
    end

    describe "#show" do
      it "returns booking information as a WatirModel" do
        booking = Model::Booking.new
        id = API::Booking.create(booking).id

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

        id = API::Booking.create.id

        show_booking = API::Booking.show(id: id).data

        expect(show_booking).to be_a Hash
      end
    end

    describe "#update" do
      it "updates booking information" do
        booking = API::Booking.create(Model::Booking.new)
        id = booking.id

        updated_booking = Model::Booking.new
        API::Booking.update(id: id, with: updated_booking)

        show_booking = API::Booking.show(id: id).booking
        expect(show_booking).to eq updated_booking
      end
    end

    describe "#destroy" do
      it "deletes booking" do
        id = API::Booking.create.id

        API::Booking.destroy(id: id)

        booking_ids = API::Booking.index.data
        expect(booking_ids.map { |b| b[:bookingid] }).to_not include(id)
      end
    end
  end
end
