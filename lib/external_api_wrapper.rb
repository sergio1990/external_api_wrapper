require 'external_api_wrapper/version'

module ExternalApiWrapper
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

  def validate_endpoint_process_class!(klass)
    return if klass.ancestors.include?(ExternalApiWrapper::BaseEndpoint)
    raise InvalidEndpointClassError,
      'The endpoint class should be derived from the `ExternalApiWrapper::BaseEndpoint` class!'
  end
end
