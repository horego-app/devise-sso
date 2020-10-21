# frozen_string_literal: true

module Devise
  module Models
    module SsoMultiDevice
      extend ActiveSupport::Concern
      extend ActiveRecord::Associations::ClassMethods

      included do
        has_many :authentication_tokens, class_name: 'Devise::Sso::AuthenticationToken', as: :resource, dependent: :destroy

        def self.enable_multi_devices?
          true
        end
      end

      def multi_device_token(request)
        authentication_tokens.actives.find_by(session_id: request.session.id)&.token
      end

      def generate_multi_device_tokens!(request)
        auth_token = authentication_tokens.find_or_initialize_by(session_id: request.session.id)
        auth_token.ip_address  = request.remote_ip
        auth_token.user_agent  = request.user_agent
        auth_token.token       = generate_authentication_token
        auth_token.active_at   = Time.zone.now
        auth_token.inactive_at = 2.days.from_now
        auth_token.save!
      end

      def reset_multi_device_tokens!(request)
        auth_token = authentication_tokens.actives.find_by(session_id: request.session.id)
        return if auth_token.blank?

        auth_token.inactivate!
      end

      def multi_device_token_valid?(token)
        authentication_tokens.find_by(token: token).nil?
      end
    end
  end
end
