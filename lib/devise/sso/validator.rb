# frozen_string_literal: true

module Devise
  module Sso
    class Validator
      attr_reader :data

      def initialize(resource_class, token)
        @resource_class = resource_class
        @token          = token
        @data           = invalid_data
      end

      def authenticate!
        return if !valid? || !resource

        @data = valid_data
      end

      def resource
        @resource ||= if @resource_class.enable_multi_devices?
                        Devise::Sso::AuthenticationToken.actives.find_by(token: @token)&.resource
                      else
                        @resource_class.find_by(authentication_token: @token)
                      end
      end

      private

      def valid?
        @token.present?
      end

      def valid_data
        data = resource
        data = resource.sso_data if defined?(resource.sso_data)

        {
          code: 200,
          messages: ['Authentication success.'],
          data: data
        }
      end

      def invalid_data
        {
          code: 401,
          messages: ['Authentication failed.'],
          data: {}
        }
      end
    end
  end
end
