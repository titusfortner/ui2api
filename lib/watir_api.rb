require "rest-client"
require "json"

module WatirApi
  class Base
    class << self

      def index(opt = {})
        rest_call(:get, route, opt)
      end

      def show(id:, **opt)
        rest_call(:get, "#{route}/#{id}", opt)
      end

      def create(obj)
        rest_call(:post, route, generate_payload(obj), content_type: :json)
      end

      def destroy(id:, **opt)
        rest_call(:delete, "#{route}/#{id}", opt)
      end

      def update(id:, with:, **opt)
        rest_call(:put, "#{route}/#{id}", generate_payload(with), opt)
      end

      def base_url=(base_url)
        @@base_url = base_url
      end

      def base_url
        @@base_url || ''
      end

      def route
        "#{base_url}/#{endpoint}"
      end

      def endpoint
        ''
      end

      private

      def rest_call(method, *args)
        RestClient.send(method, *args)
      rescue => e
        e.response
      end

      def generate_payload(obj)
        case obj
        when WatirModel
          obj.to_api
        when JSON
          # noop
        else
          obj.to_json
        end
      end
    end

  end
end
