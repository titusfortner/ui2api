require "rest-client"
require "json"

module WatirApi
  class Base
    class << self

      def index(opt = {})
        new rest_call(:get, route, opt)
      end

      def show(id:, **opt)
        new rest_call(:get, "#{route}/#{id}", opt)
      end

      def create(obj = nil)
        new rest_call(:post, route, generate_payload(obj), content_type: :json)
      end

      def destroy(id:, **opt)
        new rest_call(:delete, "#{route}/#{id}", opt)
      end

      def update(id:, with:, **opt)
        new rest_call(:put, "#{route}/#{id}", generate_payload(with), opt)
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

      def model_object
        eval "Model::#{self.to_s[/[^:]*$/]}"
      end

      private

      def rest_call(method, *args)
        RestClient.send(method, *args)
      rescue => e
        e.response
      end

      def generate_payload(obj)
        case obj
        when NilClass
          model_object.new.to_api
        when WatirModel
          obj.to_api
        when JSON
          # noop
        else
          obj.to_json
        end
      end
    end

    attr_reader :data, :code, :response

    def initialize(response)
      @response = response
      @code = response.code
      @data = JSON.parse(response.body, symbolize_names: true) rescue nil
      @data = (convert_to_model(@data) || @data) unless @data.nil? || !(defined? model_object.new)
    end

    def convert_to_model(data)
      if data.is_a? Hash
        (model_object.keys & data.keys).empty? ? return : model_object.convert(data)
      elsif data.is_a? Array
        data.map do |hash|
          model = convert_to_model(hash)
          model.nil? ? return : model
        end
      end
    end

    def model_object
      self.class.model_object
    end
  end
end
