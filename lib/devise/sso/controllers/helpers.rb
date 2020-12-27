# frozen_string_literal: true

module Devise
  module Sso
    module Controllers
      # Those helpers are convenience methods added to ApplicationController.
      module Helpers
        def authenticate_sso!
          return if sso_resource_signed_in?

          respond_to do |format|
            format.html { redirect_to sso_login_url }
            format.js { render js: "window.location.href='#{sso_login_url}';" }
          end
        end

        def sso_resource_signed_in?
          current_sso_resource.present?
        end

        def current_sso_resource
          return unless defined?(cookies)

          @current_sso_resource ||= Devise::Sso::Authentication.find(cookies[Devise::Sso.session_key])
        end

        def sso_login_url
          Devise::Sso::UrlBuilder.new(
            host: ENV.fetch('SSO_HOST'),
            port: ENV.fetch('SSO_PORT'),
            path: ENV.fetch('SSO_LOGIN_PATH', 'sso/sessions/login'),
            query: {
              sso_redirect: sso_redirect_location
            }
          ).to_s
        end

        def sso_redirect_location
          session[:sso_redirect] || request.url
        end

        def sso_logout_url
          Devise::Sso::UrlBuilder.new(
            host: ENV.fetch('SSO_HOST'),
            port: ENV.fetch('SSO_PORT'),
            path: ENV.fetch('SSO_LOGOUT_PATH', 'sso/sessions/logout')
          ).to_s
        end
      end
    end
  end
end
