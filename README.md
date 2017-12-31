# Watir API

As more web applications make use of an interface to interact with their service layer, people now have
 more flexibility to set up and verify parts of their UI tests without needing to use a browser.

This simple gem makes it easy to subclass `WatirApi::Base` and provide all of the information necessary
to interact with the different REST endpoints available in your application.

This code is designed to be used with the [watir_model gem](https://github.com/titusfortner/watir_model). The Model stores the canonical data and is used
to make it easy to compare the input and output from both the API and the UI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watir_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watir_api

## Usage

1. Set the base url
    ```ruby
    WatirApi::Base.base_url = '"https://restful-booker.herokuapp.com"'
    ```
2. Create a subclass with an endpoint:
    ```ruby
    module API
      class Booking < WatirApi::Base
        def self.endpoint
          'booking'
        end
      end
    end
    ```

3. Make API calls
    ```ruby
    booking = {firstname: "Trey",
               lastname: "Ruecker",
               totalprice: 83,
               depositpaid: true,
               bookingdates: {checkin: '2019-02-23',
                              checkout: '2019-02-27'}}
     
    API::Booking.create(booking)
    ```

4. The Array or Hash of results is accessed with `#data`
    ```ruby
    booking = {firstname: "David",
               lastname: "Jones",
               totalprice: 183,
               depositpaid: true,
               bookingdates: {checkin: '2019-03-23',
                              checkout: '2019-03-27'}}
     
    created_booking = API::Booking.create(booking)
    booking_id = created_booking.data[:bookingid]
     
    stored_booking = API::Booking.show(id: booking_id).data
     
    expect(stored_booking).to eq booking
    ```

5. Use [Watir Model](https://github.com/titusfortner/watir_model)

    Note that the code in the previous example will actually fail.
    This is because we are storing dates as `String` values and the input `String`
    does not match the output `String`

    Hashes are hard to compare, which is why we have `WatirModel`. 
    WatirModel is designed to store the canonical representation of related data in the appropriate data type,
    specifically so that data can be correctly compared.

    ```ruby
    module Model
      class BookingDates < WatirModel
        key(:checkin, data_type: Date) { Faker::Date.forward }
        key(:checkout, data_type: Date) { checkin + 4 }
      end
     
      class Booking < WatirModel
        key(:firstname) { Faker::Name.first_name }
        key(:lastname) { Faker::Name.last_name }
        key(:totalprice, data_type: Integer) { Faker::Commerce.price.round }
        key(:depositpaid) { true }
        key(:bookingdates, data_type: BookingDates) { BookingDates.new }
        key(:additionalneeds)
      end
    end
    ```

    Because we have a model class defined that is named the same as the API class, `WatirApi` will 
    automatically attempt to create an instance of the model from the return value of the API call. 
    It is accessible from a method based on the name of the API/Model classes, so in this case `#booking`:

    ```ruby
    booking = Model::Booking.new
     
    created_booking = API::Booking.create(booking)
    booking_id = created_booking.data[:bookingid]
     
    stored_booking = API::Booking.show(id: booking_id).booking
     
    expect(stored_booking).to eq booking
    ```

6. Customize

    You have a subclass, so if you need to add or change things before or after a call, just override the `WatirApi` method
    in your subclass:

    ```ruby
    module API
      class Booking < WatirApi::Base
      
        attr_reader :id
        
        def initialize(*)
          super
          return if @data.is_a?(Array)
          @id = @data[:bookingid]
        end
      end
    end
    ```
    Now we can use this like so:
    ```ruby
    booking = Model::Booking.new
     
    created_booking = API::Booking.create(booking)
     
    expect(created_booking.id).to eq created_booking.data[:bookingid]
    ```
    
    Because this pattern comes in very handy, you can use `#define_attribute` to do the same thing:
    
    ```ruby
    module API
      class Booking < WatirApi::Base
        def initialize(*)
          super
          return if @data.is_a?(Array)
          define_attribute(:id, @data[:bookingid])
        end
      end
    end
    ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/titusfortner/watir_api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
