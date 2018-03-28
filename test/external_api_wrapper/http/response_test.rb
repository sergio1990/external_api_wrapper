require 'test_helper'
require 'net/https'

class ExternalApiWrapper::Http::ResponseTest < Minitest::Test
  def raw_valid_json
    <<-JSON
      {"param": "value", "param2": "value2"}   
    JSON
  end

  def raw_invalid_json
    <<-HTTP
      <html>
        <body> </body>
      </html>
    HTTP
  end

  def build_original_response(is_success:, raw_body: nil)
    code = is_success ? 200 : 404
    original_response = stub('OriginalResponse', code: code, body: raw_body || raw_valid_json)
    original_response.responds_like_instance_of(Net::HTTPResponse)
    original_response.stubs(:is_a?).with(Net::HTTPSuccess).returns(is_success)
    original_response
  end

  def build_response(is_success: true, raw_body: nil)
    original_response = build_original_response(is_success: is_success, raw_body: raw_body)
    ExternalApiWrapper::Http::Response.new(original_response)
  end

  def test_success
    success_response = build_response(is_success: true)
    assert success_response.success?

    failure_response = build_response(is_success: false)
    refute failure_response.success?
  end

  def test_code
    response = build_response
    assert response.code.is_a?(Integer)
  end

  def test_body_when_raw_is_a_valid_json
    response = build_response
    assert response.body.is_a?(Hash)
  end

  def test_body_when_raw_is_invalid_json
    response = build_response(raw_body: raw_invalid_json)
    assert_raises ExternalApiWrapper::Http::InvalidJsonBodyError do
      response.body.is_a?(Hash)
    end
  end

  def test_raw_body
    response = build_response(raw_body: raw_valid_json)
    assert_equal raw_valid_json, response.raw_body
  end
end
