require 'external_api_wrapper/version'

module ExternalApiWrapper
  autoload :ActsAsCallable, 'external_api_wrapper/acts_as_callable'
  autoload :BaseEndpoint, 'external_api_wrapper/base_endpoint'
  autoload :Config, 'external_api_wrapper/config'
  autoload :Configurable, 'external_api_wrapper/configurable'

  module Data
    autoload :EndpointParams, 'external_api_wrapper/data/endpoint_params'
  end

  module Http
    autoload :UriBuilder, 'external_api_wrapper/http/uri_builder'
    autoload :Requester, 'external_api_wrapper/http/requester'
  end

  InvalidEndpointCodeError = Class.new(StandardError)
  InvalidEndpointClassError = Class.new(StandardError)

  def self.extended(target_module)
    target_module.extend Configurable
  end

  def register_endpoint(code, klass:)
    validate_parameters!(code, klass)
    extend_by_endpoint_methods(code, klass)
  end

  private

  def validate_parameters!(code, klass)
    validate_code!(code)
    validate_endpoint_processor_class!(klass)
  end

  def extend_by_endpoint_methods(code, klass)
    api_methods_module = Module.new do
      define_method code do |params|
        params = params.merge(base_url: config.base_url)
        klass.call(params)
      end
    end
    extend api_methods_module
  end

  def validate_code!(code)
    return if code.is_a?(Symbol)
    raise InvalidEndpointCodeError, "The endpoint code `#{code}` is invalid! It should be a Symbol!"
  end

  def validate_endpoint_processor_class!(klass)
    return if klass.ancestors.include?(ExternalApiWrapper::BaseEndpoint)
    raise InvalidEndpointClassError,
      'The endpoint class should be derived from the `ExternalApiWrapper::BaseEndpoint` class!'
  end
end
