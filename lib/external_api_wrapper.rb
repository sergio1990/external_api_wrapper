require "external_api_wrapper/version"

module ExternalApiWrapper
  InvalidEndpointCodeError = Class.new(StandardError)
  InvalidEndpointClassError = Class.new(StandardError)

  def self.extended(target_module)
    target_module.extend Configurable
  end

  def register_endpoint(code, klass:)
    unless code.is_a?(Symbol)
      raise InvalidEndpointCodeError, "The endpoint code `#{code}` is invalid! It should be a Symbol!"
    end
    unless klass.ancestors.include?(ExternalApiWrapper::BaseEndpoint)
      raise InvalidEndpointClassError, 'The endpoint class should be derived from the `ExternalApiWrapper::BaseEndpoint` class!'
    end
    api_methods_module = Module.new do
      define_method code do |params|
        params = params.merge(base_url: self.config.base_url)
        klass.call(params)
      end
    end
    self.extend api_methods_module
  end
end
