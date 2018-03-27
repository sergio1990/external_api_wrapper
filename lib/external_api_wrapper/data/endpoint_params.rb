module ExternalApiWrapper
  module Data
    class EndpointParams
      attr_accessor :query_params, :url_params, :headers, :base_url

      def initialize(base_url:, query_params:, url_params:, headers: {})
        @query_params = query_params
        @url_params = url_params
        @headers = headers
        @base_url = base_url
      end
    end
  end
end
