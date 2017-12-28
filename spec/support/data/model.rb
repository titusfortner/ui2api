require 'faker'

module WatirApi
  module Model
    class BookingDates < WatirModel
      key(:checkin) { Date.today + 1 }
      key(:checkout) { Date.today + 7 }
    end

    class Booking < WatirModel
      key(:firstname) { Faker::Name.first_name }
      key(:lastname) { Faker::Name.last_name }
      key(:totalprice) { Faker::Commerce.price }
      key(:depositpaid) { true }
      key(:bookingdates) { BookingDates.new }
      key(:additionalneeds) { 'Breakfast' }
    end
  end
end
