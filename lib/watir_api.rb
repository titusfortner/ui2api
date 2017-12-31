require "rest-client"
require "json"
require 'active_support/inflector'

module WatirApi
  class Base
    class << self

      def index(opt = {})
        new rest_call({method: :get,
                       url: route(opt)}.merge opt)
      end

      def show(id:, **opt)
        new rest_call({method: :get,
                       url: "#{route(opt)}/#{id}".chomp('/')}.merge opt)
      end

      def create(obj = nil, opt = {})
        new rest_call({method: :post,
                       url: route(opt),
                       payload: generate_payload(obj)}.merge opt)
      end

      def destroy(id:, **opt)
        new rest_call({method: :delete,
                       url: "#{route(opt)}/#{id}".chomp('/')}.merge opt)
      end

      def update(id:, with:, **opt)
        new rest_call({method: :put,
                       url: "#{route(opt)}/#{id}".chomp('/'),
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
        opt[:headers] ||= headers
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

    attr_reader :response, :code, :header, :data

    def initialize(args)
      response, _request, _result = *args
      @response = response
      @code = response.code
      @header = response.instance_variable_get('@headers')
      @data = JSON.parse(response.body, symbolize_names: true) rescue nil

      set_watir_model_attr
    end

    def set_watir_model_attr
      return unless defined?(model_object.new)
      model = convert_to_model(@data) unless @data.nil?
      var = model_object.to_s[/[^:]*$/].downcase
      var = var.pluralize if @data.is_a? Array
      instance_variable_set "@#{var}", model
      singleton_class.class_eval { attr_accessor var }
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
