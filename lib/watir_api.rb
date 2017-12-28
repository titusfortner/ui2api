require 'rest-client'

module WatirApi
  module API
    class Base
      class << self

        def create(obj, opt = {})
          expected_object = opt[:expected_object] || Object.const_get(self.to_s.gsub('API', 'Data'))
          obj ||= expected_object.new if defined?(expected_object)
          result = api_call(payload: obj.to_api, method: :post)
          opt = update_create_results(result) || {}
          new(obj, opt)
        end

        def index(opt = {})
          opt[:method] = :get
          api_call(opt)
        end

        def show(obj)
          opt = {method: :get,
                 url: "#{Site.base_url}/#{endpoint}/#{obj.id}"}
          api_call(opt)
        end

        def update(obj, payload)
          opt = {method: :put,
                 url: "#{Site.base_url}/#{endpoint}/#{obj.id}",
                 payload: payload}
          api_call(opt)
        end

        def destroy(obj)
          opt = {method: :delete,
                 url: "#{Site.base_url}/#{endpoint}/#{obj.id}"}
          api_call(opt)
        end

        def data_object
          self.to_s[/[^:]*$/].downcase.to_sym
        end

        private

        def update_results(*)
          # implement in subclass as necessary
        end

        def headers
          cookies = Site.browser.cookies.to_a
          remember_token = cookies.find { |cookie| cookie[:name] == "remember_token" }
          opt = {"Content-Type" => "application/json"}
          return opt if remember_token.nil?
          remember = remember_token[:value]
          session_cookie = cookies.find { |cookie| cookie[:name] == "_address_book_session" }
          session = session_cookie.nil? ? '' : session_cookie[:value]
          opt['Cookie'] = "remember_token=#{remember}; address_book_session=#{session}"
          opt
        end

        def api_call(opt)
          call = {method: opt[:method]}
          call[:url] = opt[:url] || "#{Site.base_url}/#{endpoint}"
          call[:verify_ssl] = opt[:ssl] if opt.key?(:ssl)
          call[:payload] = opt[:payload] if opt[:payload]
          call[:headers] = opt[:headers] || headers
          RestClient::Request.execute(call) do |_resp, _req, result|
            result
          end
        end
      end

      attr_accessor :data_object

      def initialize(obj, opt = {})
        opt[self.class.data_object] = obj
        opt.each do |key, value|
          instance_variable_set("@#{key}", value)
          self.class.__send__(:attr_accessor, key)
        end
      end

      def data_object
        eval(self.class.data_object.to_s)
      end

      def method_missing(method, *args, &block)
        data_object.send method, *args, &block
      end

      def respond_to_missing?(method, *args)
        data_object.respond_to?(method) || super
      end
    end
  end
end
