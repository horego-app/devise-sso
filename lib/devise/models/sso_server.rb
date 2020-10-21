# frozen_string_literal: true

module Devise
  module Models
    module SsoServer
      def authentication_token(request = {})
        return multi_device_token(request) if self.class.enable_multi_devices? && request.present?

        attributes['authentication_token']
      end

      def generate_authentication_token!(request = {})
        return generate_multi_device_tokens!(request) if self.class.enable_multi_devices? && request.present?

        self.authentication_token = generate_authentication_token
        save!
      end

      def reset_authentication_token!(request = {})
        return reset_multi_device_tokens!(request) if self.class.enable_multi_devices? && request.present?

        self.authentication_token = nil
        save!
      end

      def generate_authentication_token
        loop do
          token = Devise.friendly_token
          break token unless token_valid?(token)
        end
      end

      def token_valid?(token)
        return multi_device_token_valid?(token) if self.class.enable_multi_devices?

        self.class.find_by(authentication_token: token).nil?
      end
    end
  end
end
