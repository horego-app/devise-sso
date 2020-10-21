# frozen_string_literal: true

require 'devise/sso/version'

module Devise
  module Sso
    class Error < StandardError; end

    def self.session_key
      :devise_sso_token
    end
  end
end

require 'devise/sso/rails'
require 'devise/sso/controllers/helpers'
require 'devise/sso/authentication'
require 'devise/sso/authentication_token'
require 'devise/sso/validator'

Devise.with_options model: true do |d|
  routes = %i[new create destroy]
  d.add_module :sso_server, controller: 'devise/sso/sessions', route: { session: routes }
  d.add_module :sso_multi_device
end

ActiveSupport.on_load(:action_controller) do
  include Devise::Sso::Controllers::Helpers if defined?(Devise::Sso::Controllers::Helpers)

  if respond_to?(:helper_method)
    helper_method :current_sso_resource, :sso_resource_signed_in?, :sso_session
  end
end
