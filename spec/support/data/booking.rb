module WatirApi
  module Model
    class BookingDates < Base
      key(:checkin, data_type: Date) { Faker::Date.forward }
      key(:checkout, data_type: Date) { checkin + 4 }
    end

    class Booking < Base
      key(:firstname) { Faker::Name.first_name }
      key(:lastname) { Faker::Name.last_name }
      key(:totalprice, data_type: Integer) { Faker::Commerce.price.round }
      key(:depositpaid) { true }
      key(:bookingdates, data_type: BookingDates) { BookingDates.new }
      key(:additionalneeds) { 'Breakfast' }
    end
  end
end
