# frozen_string_literal: true

module Devise
  module Sso
    class SessionsController < Devise::SessionsController
      before_action :sso_store_location!, only: [:new]
      skip_before_action :verify_authenticity_token, only: [:destroy]
      before_action :validate_sso_domain, only: [:destroy]

      def create
        super do |resource|
          resource.generate_authentication_token!(request)
          store_session_token!(resource)
        end
      end

      def destroy
        token = sso_session # put here before session's cleared

        super do
          resource = resource_class.find_by(authentication_token: token)
          resource&.reset_authentication_token!(request)

          remove_session_token!
        end
      end

      private

      def verify_signed_out_user
        return if sso_resource_signed_in?

        super
      end

      def require_no_authentication
        return unless sso_resource_signed_in?

        super
      end

      def validate_sso_domain
        return if ['.', request.domain].join.casecmp(ENV.fetch('SSO_SHARED_DOMAIN', '.lvh.me'))

        redirect_location = request.referer || '/'
        respond_to do |format|
          format.html { redirect_back(fallback_location: redirect_location) }
          format.js { render js: "window.location.href='#{redirect_location}';" }
        end
      end

      def sso_store_location!
        redirect_url = params.delete(:sso_redirect)
        session[:sso_redirect] = redirect_url if redirect_url.present?
      end

      def store_session_token!(resource)
        session[Devise::Sso.session_key] = resource.authentication_token(request)
        cookies[Devise::Sso.session_key] = { value: resource.authentication_token(request), domain: ENV.fetch('SSO_SHARED_DOMAIN', '.lvh.me') }
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
