# frozen_string_literal: true

require 'uri'

module Devise
  module Sso
    class UrlBuilder
      def initialize(**params)
        @params = params.symbolize_keys

        normalize_host
        normalize_path
        normalize_query
      end

      def uri
        uri_klass.build(@params)
      end

      def to_s
        uri.to_s
      end

      private

      def uri_klass
        return URI::HTTPS if @params[:port]&.to_i == 443 && @params.delete(:port)

        URI::HTTP
      end

      def normalize_host
        host = @params[:host]
        return '' if host.nil?

        regex = %r{^(http:|https:)|(\/)}
        @params[:host] = host.gsub(regex, '')
      end

      def normalize_path
        path = @params[:path]
        return '' if path.nil?

        path = path.gsub(%r{^\/*}, '')
        @params[:path] = path.prepend('/')
      end

      def normalize_query
        query = @params[:query] || {}
        return '' if query.blank? || !query.is_a?(Hash)

        @params[:query] = query.to_query
      end
    end
  end
end
