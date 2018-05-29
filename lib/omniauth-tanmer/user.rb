require "faraday"
require "jwt"
module Omniauth
  module Tanmer
    class User
      attr_reader :app_id, :app_secret, :conn

      def initialize(oauth_host, app_id, app_secret)
        @app_id = app_id
        @app_secret = app_secret
        @conn = Faraday.new(oauth_host)
      end

      def create(name: nil, username: nil, email: nil, mobile_phone: nil, image: nil, password: nil)
        params = {
          app_id: app_id,
          sn: generate_sn(SecureRandom.uuid),
          name: name,
          username: username,
          email: email,
          mobile_phone: mobile_phone,
          image: image,
          password: password
        }
        resp = conn.post('/api/v1/users.json', params)
        JSON.parse(resp.body)
      end

      private

      def generate_sn(data=nil)
        JWT.encode({ data: data, exp: Time.now.to_i + 300 }, app_secret, 'HS256')
      end
    end
  end
end
