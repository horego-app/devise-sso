# frozen_string_literal: true

module Devise
  module Models
    module SsoServer
      def generate_authentication_token!
        self.authentication_token = SecureRandom.hex.slice(0, 30)
        save!
      end

      def reset_authentication_token!
        self.authentication_token = nil
        save!
      end
    end
  end
end
