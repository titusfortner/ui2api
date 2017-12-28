require "rest-client"
require "json"

module WatirApi
  class Base
    class << self

      def index
        RestClient.get(base_url)
      rescue => e
        e.response
      end

      def show(id)
        RestClient.get "#{base_url}/#{id}"
      rescue => e
        e.response
      end

      def create(payload)
        RestClient.post base_url, payload, content_type: :json
      rescue => e
        e.response
      end

      def base_url=(base_url)
        @@base_url = base_url
      end

      def base_url
        @@base_url
      end
    end

  end
end
