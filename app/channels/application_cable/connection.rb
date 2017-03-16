module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
    def find_verified_user
      logger.add_tags 'ActionCable'
      if request.params[:jwt].present?
        logger.add_tags 'With JWT'
      end

      jwt_params = jwt_decode
      logger.debug "JWT Params: #{jwt_params}"
      if jwt_params
        if jwt_params.keys.include? 'id'
          current_user = User.find jwt_params['id']
          logger.add_tags "User ID: #{jwt_params['id']}"
        else
          logger.debug 'Unauthorized for no id'
          reject_unauthorized_connection
        end
      else
        logger.debug 'Unauthorized for failing to decode'
        reject_unauthorized_connection
      end

      current_user
    end

    def jwt_decode
      token = request.params[:jwt]
      begin
        JWTWrapper.decode(token)
      rescue => e
        logger.debug e
        false
      end
    end
  end
end
