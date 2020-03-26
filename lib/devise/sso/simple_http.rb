# frozen_string_literal: true

require 'net/http'
require 'devise/sso/url_builder'

module Devise
  module Sso
    class SimpleHttp
      HTTP_KLASS = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        delete: Net::HTTP::Delete
      }.freeze

      def initialize(**params)
        @params = params
      end

      def perform(http_method)
        Net::HTTP.start(uri.host, uri.port, use_ssl: ssl?) do |http|
          request = HTTP_KLASS[http_method.to_sym].new(uri, @params[:headers])
          yield request if block_given?

          http.request request
        end
      end

      def uri
        UrlBuilder.new(@params).uri
      end

      def ssl?
        @params[:port]&.to_i == 443
      end
    end
  end
end
