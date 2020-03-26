# frozen_string_literal: true

module Devise
  module Sso
    class SessionsController < Devise::SessionsController
      before_action :sso_store_location!, only: [:new]

      def create
        super do |resource|
          resource.generate_authentication_token!
          store_session_token!(resource)
        end
      end

      def destroy
        token = sso_session # put here before session's cleared

        super do
          resource = resource_class.find_by(authentication_token: token)
          resource&.reset_authentication_token!

          remove_session_token!
        end
      end

      private

      def sso_store_location!
        redirect_url = params.delete(:sso_redirect)
        session[:sso_redirect] = redirect_url if redirect_url.present?
      end

      def store_session_token!(resource)
        session[Devise::Sso.session_key] = resource.authentication_token
        cookies[Devise::Sso.session_key] = { value: resource.authentication_token, domain: ENV.fetch('SSO_SHARED_DOMAIN', '.lvh.me') }
      end

      def remove_session_token!
        session[Devise::Sso.session_key] = nil
        cookies.delete(Devise::Sso.session_key, domain: ENV.fetch('SSO_SHARED_DOMAIN', '.lvh.me'))
      end

      def sso_session
        session[Devise::Sso.session_key]
      end
    end
  end
end
