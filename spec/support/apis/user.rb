module UI2API
  module API
    class User < ABBase
      class << self
        def endpoint
          'users'
        end

        def model_object
          Model::ABUser
        end

        def create(user = nil, opt = {})
          user ||= Model::ABUser.new
          opt[:headers] ||= {content_type: :json}
          super(user, opt)
        end

        def show(opt = {})
          opt[:endpoint] ||= 'current_user'
          opt[:id] = ''
          super(opt)
        end
      end

      attr_accessor :remember_token

      def initialize(*)
        super
        rt = @header[:set_cookie].find { |cookie| cookie.match(/remember_token/) }
        @remember_token = rt[/^remember_token=([^;]*)/, 1]

        ABSite.user = self
      end
    end
  end
end
