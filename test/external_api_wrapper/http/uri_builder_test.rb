require 'test_helper'

class ExternalApiWrapper::Http::UriBuilderTest < Minitest::Test
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

  def uri
    @uri ||= ExternalApiWrapper::Http::UriBuilder.new(
      path: '/rest/v1/entity/{id}',
      endpoint_params: params
    )
  end

  def test_builds_proper_full_url
    assert_equal 'https://google.com/rest/v1/entity/1?locale=en', uri.call.to_s
  end
end
