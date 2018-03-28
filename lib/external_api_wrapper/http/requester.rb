require 'net/https'

module ExternalApiWrapper
  module Http
    class Requester
      include ActsAsCallable

      def initialize(uri:, headers:)
        @uri = uri
        @headers = headers
      end

      def call
        http = build_http
        response = do_request(http)
        ExternalApiWrapper::Http::Response.new(response)
      end

      private

      def build_http
        http = Net::HTTP.new(uri.host, uri.inferred_port)
        http = apply_ssl(http) if uri.scheme == 'https'
        http
      end

      def do_request(http)
        request = Net::HTTP::Get.new(uri.request_uri)
        request = apply_request_headers(request)
        http.request(request)
      end

      def apply_ssl(http)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def apply_request_headers(request)
        headers.each do |name, value|
          request[name] = value
        end
        request
      end

      attr_reader :uri
      attr_reader :headers
    end
  end
end
