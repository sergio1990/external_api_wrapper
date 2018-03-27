require 'test_helper'

ValidEndpointProcess = Class.new(::ExternalApiWrapper::BaseEndpoint)
InvalidEndpointProcess = Class.new

class ExternalApiWrapperTest < Minitest::Test
  def build_api_module
    Module.new do
      extend ::ExternalApiWrapper
    end
  end

  def test_extend_adds_configurable_concern
    api_module = build_api_module
    assert api_module.respond_to?(:config)
    config = api_module.config
    assert config.is_a?(::ExternalApiWrapper::Config)
  end

  def test_extend_adds_register_endpoint_api
    api_module = build_api_module
    assert api_module.respond_to?(:register_endpoint)
  end

  def test_register_endpoint_when_all_parameters_are_valid
    api_module = build_api_module
    api_module.register_endpoint :api_method, klass: ValidEndpointProcess
    assert api_module.respond_to?(:api_method)
  end

  def test_register_endpoint_when_code_is_invalid
    api_module = build_api_module
    assert_raises ::ExternalApiWrapper::InvalidEndpointCodeError do
      api_module.register_endpoint 'some_api_method', klass: ValidEndpointProcess
    end
  end

  def test_register_endpoint_when_processor_is_invalid
    api_module = build_api_module
    assert_raises ::ExternalApiWrapper::InvalidEndpointClassError do
      api_module.register_endpoint :api_method, klass: InvalidEndpointProcess
    end
  end
end
