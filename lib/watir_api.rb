require "rest-client"
require "json"

module WatirApi
  class Base
    class << self

      def index(opt = {})
        new rest_call({method: :get,
                      url: route}.merge opt)
      end

      def show(id:, **opt)
        new rest_call({method: :get,
                      url: "#{route}/#{id}".chomp('/')}.merge opt)
      end

      def create(obj = nil)
        new rest_call(method: :post,
                      url: route,
                      payload: generate_payload(obj),
                      headers: headers)
      end

      def destroy(id:, **opt)
        new rest_call({method: :delete,
                      url: "#{route}/#{id}".chomp('/')}.merge opt)
      end

      def update(id:, with:, **opt)
        new rest_call({method: :put,
                      url: "#{route}/#{id}".chomp('/'),
                      payload: generate_payload(with)}.merge opt)
      end

      def base_url=(base_url)
        @@base_url = base_url
      end

      def base_url
        @@base_url || ''
      end

      def route(opt = {})
        "#{opt[:base_url] || base_url}/#{opt.delete(:endpoint) || endpoint}"
      end

      def endpoint
        ''
      end

      def model_object
        eval "Model::#{self.to_s[/[^:]*$/]}"
      end

      private

      def rest_call(opt)
        opt[:verify_ssl] = opt.delete(:ssl) if opt.key?(:ssl)
        opt[:headers] = opt.delete(:headers) || headers
        RestClient::Request.execute(opt) do |response, request, result|
          [response, request, result]
        end
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

      def headers
        {content_type: :json}
      end
    end

    attr_reader :data, :code, :response

    def initialize(args)
      response, request, _result = *args
      @response = response
      @code = response.code
      @header = request.instance_variable_get('@header')
      @data = JSON.parse(response.body, symbolize_names: true) rescue nil
      @data = (convert_to_model(@data) || @data) unless @data.nil? || !(defined? model_object.new)
    end

    def convert_to_model(data)
      if data.is_a? Hash
        return if (model_object.valid_keys & data.keys).empty?
        begin
          model_object.convert(data)
        rescue StandardError => ex
          raise unless ex.message.include?('Can not convert Hash to Model')
        end
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
