module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers['Authorization'].present? && (request.content_type == "application/json")
      end

      def authenticate!
        claim = claims
        return fail! unless claim
        return fail! unless claim.has_key?('user_id')

        success! User.find_by_id claim['user_id']
      end

      protected

      def claims
        strategy, token = request.headers['Authorization'].split(' ')
        return nil if (strategy || '').downcase != 'bearer'

        JWTWrapper.decode(token) rescue nil
      end
    end
  end
end
