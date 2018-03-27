require 'test_helper'

class ExternalApiWrapper::Data::EndpointParamsTest < Minitest::Test
  def params
    @params ||= ExternalApiWrapper::Data::EndpointParams.new(
      base_url: 'https://google.com',
      query_params: {locale: 'en'},
      url_params: {id: '1'},
      headers: {
        :'Accept' => 'application/json'
      }
    )
  end

  def test_params_object_provides_sufficient_api
    assert params.respond_to?(:query_params)
    assert params.respond_to?(:url_params)
    assert params.respond_to?(:base_url)
    assert params.respond_to?(:headers)
  end
end
