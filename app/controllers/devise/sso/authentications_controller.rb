# frozen_string_literal: true

module Devise
  module Sso
    class AuthenticationsController < DeviseController
      skip_before_action :verify_authenticity_token

      def create
        sso = Devise::Sso::Validator.new(resource_class, token)
        sso.authenticate!

        render json: sso.data, status: sso.data[:code]
      end

      private

      def token
        params.require(:token)
      end
    end
  end
end
