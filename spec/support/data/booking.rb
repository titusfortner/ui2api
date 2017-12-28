module WatirApi
  module Model
    class BookingDates < Base
      key(:checkin) { Date.today + 1 }
      key(:checkout) { Date.today + 7 }
    end

    class Booking < Base
      key(:firstname) { Faker::Name.first_name }
      key(:lastname) { Faker::Name.last_name }
      key(:totalprice) { Faker::Commerce.price }
      key(:depositpaid) { true }
      key(:bookingdates) { BookingDates.new }
      key(:additionalneeds) { 'Breakfast' }
    end
  end
end
