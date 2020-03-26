# frozen_string_literal: true

module Devise
  module Sso
    module Controllers
      # Those helpers are convenience methods added to ApplicationController.
      module Helpers
        def authenticate_sso!
          redirect_to sso_login_url unless sso_resource_signed_in?
        end

        def sso_login_url
          '/' # Override this on your controller
        end

        def sso_resource_signed_in?
          current_sso_resource.present?
        end

        def current_sso_resource
          @current_sso_resource ||= Devise::Sso::Authentication.find(cookies[Devise::Sso.session_key])
        end
      end
    end
  end
end
