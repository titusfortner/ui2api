require "rest-client"
require "json"

module WatirApi
  class Base
    class << self

      def index
        RestClient.get route
      rescue => e
        e.response
      end

      def show(id)
        RestClient.get "#{route}/#{id}"
      rescue => e
        e.response
      end

      def create(payload)
        RestClient.post route, payload, content_type: :json
      rescue => e
        e.response
      end

      def destroy(id, opt)
        RestClient.delete "#{route}/#{id}", opt
      rescue => e
        e.response
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
    end

  end
end
