# frozen_string_literal: true

require 'devise/sso/simple_http'

module Devise
  module Sso
    class Authentication
      def initialize(token)
        @token = token
      end

      def self.find(token)
        new(token).authenticate!
      end

      def authenticate!
        return nil if @token.blank?

        res  = call_sso_server
        data = JSON.parse(res.body)['data'] || {}
        return if data.blank?

        OpenStruct.new(data)
      end

      private

      def call_sso_server
        shttp = SimpleHttp.new(
          host: ENV.fetch('SSO_HOST'),
          port: ENV.fetch('SSO_PORT'),
          path: ENV.fetch('SSO_AUTH_PATH', 'sso/authenticate')
        )

        shttp.perform(:post) do |request|
          request.form_data = { token: @token }
        end
      end
    end
  end
end
