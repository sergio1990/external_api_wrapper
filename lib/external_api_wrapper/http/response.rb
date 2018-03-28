require 'json'

module ExternalApiWrapper
  module Http
    InvalidJsonBodyError = Class.new(BaseError)

    class Response
      def initialize(original_response)
        @original_response = original_response
      end

      def success?
        original_response.is_a?(Net::HTTPSuccess)
      end

      def code
        @code ||= original_response.code.to_i
      end

      def body
        @body ||= JSON.parse(raw_body, symbolize_names: true)
      rescue JSON::ParserError => e
        raise InvalidJsonBodyError, e.message
      end

      def raw_body
        @raw_body ||= original_response.body
      end

      private

      attr_reader :original_response
    end
  end
end
