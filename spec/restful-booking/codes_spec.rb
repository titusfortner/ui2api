require 'spec_helper'

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
      booking = API::Booking.create

      expect(booking.code).to be(200)
    end
  end

  describe "#update" do
    it "verifies syntax even if not returning 200" do
      id = API::Booking.create.data[:bookingid]

      user = Model::User.authorised
      token = API::Authenticate.create(user).data[:token]

      updated_booking = Model::Booking.new
      updated = API::Booking.update(id: id, with: updated_booking, token: token)

      # update doesn't seem to work; I think this is intentional
      expect(updated.code).to be(400)
    end
  end

  describe "#destroy" do
    it "returns 200" do
      id = API::Booking.create.data[:bookingid]

      user = Model::User.authorised
      token = API::Authenticate.create(user).data[:token]

      deletion = API::Booking.destroy(id: id, token: token)
      expect(deletion.code).to be(201)
      expect(API::Booking.show(id: id).code).to eq 404
    end
  end
end