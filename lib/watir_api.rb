require "rest-client"
require "json"

module WatirApi
  class Base
    class << self

      def index
        rest_call(:get, route)
      end

      def show(opt)
        id = opt.delete :id
        rest_call(:get, "#{route}/#{id}", opt)
      end

      def create(payload)
        rest_call(:post, route, payload, content_type: :json)
      end

      def destroy(id, opt)
        rest_call(:delete, "#{route}/#{id}", opt)
      end

      def update(id, payload, opt)
        rest_call(:put, "#{route}/#{id}", payload, opt)
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
    end

  end
end
