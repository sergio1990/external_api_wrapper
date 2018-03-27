module ExternalApiWrapper
  InvalidEndpointParamsError = Class.new(StandardError)

  class BaseEndpoint
    include ActsAsCallable

    def initialize(raw_params)
      check_raw_params_for_required_keys!(raw_params)
      @params = process_raw_params(raw_params)
    end

    def call
      raw_response = do_http_request
      parse_response(raw_response)
    end

    protected

    def required_params_keys
      raise NotImplementedError
    end

    def process_raw_params(_raw_params)
      raise NotImplementedError
    end

    def endpoint_path
      raise NotImplementedError
    end

    def response_parser
      raise NotImplementedError
    end

    private

    attr_reader :params

    def check_raw_params_for_required_keys!(raw_params)
      raw_params_keys = raw_params.keys
      required_params_keys.each do |required_key|
        next if raw_params_keys.include?(required_key)
        raise InvalidEndpointParamsError, "The entry with a key `#{required_key}` is required!"
      end
    end

    def do_http_request
      uri = build_uri
      ExternalApiWrapper::Http::Requester.call(uri: uri, headers: params.headers)
    end

    def parse_response(raw_response)
      response_parser.call(raw_response)
    end

    def build_uri
      Http::UriBuilder.call(path: endpoint_path, endpoint_params: params)
    end
  end
end
