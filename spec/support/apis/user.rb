module WatirApi
  module API
    class User < Base
      class << self
        def endpoint
          'users'
        end

        def update_create_results(result)
          header = result.instance_variable_get('@header')
          cookie = header['set-cookie'][1]
          remember_token = cookie[/^remember_token=([^;]*)/, 1]
          {remember_token: remember_token}
        end

        def show
          opt = {method: :get,
                 url: "#{Site.base_url}/current_user"}
          api_call(opt)
        end
      end

    end
  end
end