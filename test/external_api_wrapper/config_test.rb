require 'test_helper'

class ExternalApiWrapper::ConfigTest < Minitest::Test
  def config
    @config ||= ExternalApiWrapper::Config.new
  end

  def test_config_obj_provides_sufficient_api
    assert config.respond_to?(:base_url)
    assert config.respond_to?(:base_url=)
  end
end
