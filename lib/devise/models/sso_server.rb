# frozen_string_literal: true

module Devise
  module Models
    module SsoServer
      def generate_authentication_token!
        self.authentication_token = generate_authentication_token
        save!
      end

      def reset_authentication_token!
        self.authentication_token = nil
        save!
      end

      def generate_authentication_token
        loop do
          token = Devise.friendly_token
          break token unless self.class.find_by(authentication_token: token)
        end
      end
    end
  end
end
