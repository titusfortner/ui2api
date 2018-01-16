require "rest-client"
require "json"
require 'active_support/inflector'
require 'json-schema-generator'
require 'json-schema'


module UI2API
  class Base
    class << self

      def schema_path=(schema_path)
        @@schema_path = schema_path
      end

      def schema_path
        @@schema_path ||= 'schemas'
      end

      def generate_schema=(generate)
        @@generate_schema = generate
      end

      def generate_schema
        @@generate_schema ||= nil
      end

      def validate_schema=(validate)
        @@validate_schema = validate
      end

      def validate_schema
        @@validate_schema ||= nil
      end

      def schema_version
        @schema_version || 'draft4'
      end

      def index(opt = {})
        new :index, rest_call({method: :get,
                       url: route(opt)}.merge opt)
      end

      def show(id:, **opt)
        new :show, rest_call({method: :get,
                       url: "#{route(opt)}/#{id}".chomp('/')}.merge opt)
      end

      def create(obj = nil, opt = {})
        new :create, rest_call({method: :post,
                       url: route(opt),
                       payload: generate_payload(obj)}.merge opt)
      end

      def destroy(id:, **opt)
        new :destroy, rest_call({method: :delete,
                       url: "#{route(opt)}/#{id}".chomp('/')}.merge opt)
      end

      def update(id:, with:, **opt)
        new :update, rest_call({method: :put,
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

    def initialize(caller, args)
      @caller = caller
      @response, _request, _result = *args
      @response = response
      @code = @response.code
      @header = @response.instance_variable_get('@headers')
      @data = begin
        JSON.parse(@response.body, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end

      set_watir_model_attr

      return if @data.nil?

      if self.class.generate_schema
        generate_schema
      elsif self.class.validate_schema
        validate_schema
      end
    end

    def set_watir_model_attr
      return unless defined?(model_object.new)
      model = convert_to_model(@data) unless @data.nil?
      var = model_object.to_s[/[^:]*$/].underscore
      var = var.pluralize if @data.is_a? Array
      define_attribute(var, model)
      define_attribute(:id, @data[:id]) if @data.is_a? Hash
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

    private

    def generate_schema
      path = "schemas/#{self.class.endpoint}/"
      FileUtils.mkdir_p(path)

      file = "#{path}/#{@caller}.json"
      File.open(file, 'w') { |f| f.puts @response.body }

      schema_file = file.gsub(".json", ".schema")

      schema = JSON::SchemaGenerator.generate file, File.read(file), {schema_version: @schema_version}
      File.open(schema_file, 'w') { |f| f.puts schema }
    end

    def validate_schema
      path = "schemas/#{self.class.endpoint}/"
      file = "#{path}/#{@caller}.schema"
      JSON::Validator.validate!(file, @response.body)
    end

    def define_attribute(key, value)
      instance_variable_set("@#{key}", value)
      singleton_class.class_eval { attr_reader key }
    end
  end
end
