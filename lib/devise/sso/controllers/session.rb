# frozen_string_literal: true

module Devise
  module Sso
    module Controller
      module Session
        def store_session_token!(resource_name, resource)
          session[Devise::Sso.session_key] = resource.authentication_token
        end

        def remove_session_token!(resource_name)
          session[Devise::Sso.session_key] = nil
        end

        def sso_session
          session[Devise::Sso.session_key]
        end
      end
    end
  end
end
