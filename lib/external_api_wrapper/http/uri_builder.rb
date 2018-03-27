require 'addressable/template'

module ExternalApiWrapper
  module Http
    class UriBuilder
      include ActsAsCallable

      def initialize(path:, endpoint_params:)
        @path = path
        @endpoint_params = endpoint_params
      end

      def call
        uri = build_uri_with_expanded_params
        uri.query = endpoint_params.query_params.to_query
        uri
      end

      private

      attr_reader :path, :endpoint_params

      def build_uri_with_expanded_params
        uri_template = Addressable::Template.new("#{endpoint_params.base_url}#{path}")
        uri_template.expand(endpoint_params.url_params)
      end
    end
  end
end
