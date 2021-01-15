module API
  module V1
    module Helpers
      module AuthenticationHelpers
        def authenticate_user!
          token = request.headers["Jwt-Token"]
          user_id = Authentication.decode(token)["user_id"] if token
          @current_user = User.find_by id: user_id
          return if @current_user

          api_error!("You need to log in to use the app", "failure", 401, {})
        end

        def api_error! message, error_code, status, header
          error!({message: message, code: error_code}, status, header)
        end

        def current_user
          @current_user
        end
      end
    end
  end
end
