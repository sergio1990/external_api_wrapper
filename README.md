# ExternalApiWrapper

[![Maintainability](https://api.codeclimate.com/v1/badges/0ca18305c1383d977297/maintainability)](https://codeclimate.com/github/sergio1990/external_api_wrapper/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0ca18305c1383d977297/test_coverage)](https://codeclimate.com/github/sergio1990/external_api_wrapper/test_coverage)
[![Build Status](https://travis-ci.org/sergio1990/external_api_wrapper.svg?branch=master)](https://travis-ci.org/sergio1990/external_api_wrapper)
[![Dependency Status](https://gemnasium.com/badges/github.com/sergio1990/external_api_wrapper.svg)](https://gemnasium.com/github.com/sergio1990/external_api_wrapper)

I like to practive the approach to wrap the 3rd-party API usages. In most cases, to call some API the steps are pretty the same:

- build a full URI to the desired endpoint
- extend the URI by the query parameters
- do a HTTP request
- parse the response and provide it to the client code

When you work only with the one 3rd party service it okay, but after adding more and more external services to work with the process to create the wrappers becomes boring and contains repetitive steps with a lot of simple copy-paste actions.
The decision to extract some abstraction should be very deliberated, but I've decided to make the one to more easily create 3rd-party API wrappers.

There are a lot of cases, which aren't covered by this library and based on only on the needs of the projects on which I work, but all suggestions and PRs are welcome 😏

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'external_api_wrapper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install external_api_wrapper

## Usage

To use this library a plenty steps should be passed, but they are pretty simple and straightforward, I hope 😋 I am going to describe all of them in an order below.

### 1. Decide which module will be like a facade and provide a configuration

Let's imagine, that `SomeApi` module will be an API facade. So, to allow that, you have to extend it by `ExternalApiWrapper` module like the following:

```ruby
module SomeApi
  extend ::ExternalApiWrapper
end
```

Then, you need to provide a general configuration. It's very simple and requires only a base URL:

```ruby
::SomeApi.config do |api_config|
  api_config.base_url = ENV['SOME_API_BASE_URL']
end
```

### 2. Register an endpoint

After defining the facade module you have to setup one or more endpoints. For that, you should use `register_endpoint` class method, which expects the following information to be passed:

- endpoint code
- endpoint processing class

For example:

```ruby
module SomeApi
  extend ::ExternalApiWrapper
  
  register_endpoint :get_info, klass: SomeApi::GetInfo::Endpoint
end
```

### 3. Define endpoint processing class

The whole processing work is hidden under the `ExternalApiWrapper::BaseEndpoint` abstract class, but you have to setup parts, which are uniq for each endpoint:

- required parameters list
- map an income hash with parameters into the parameter object, which will be used in the lower layers
- an endpoint's URL path. As you remember, the base URL is set separately
- an endpoint's response parser class - will map the general response hash into the value objects, for example. But nothing resist you to use just response hash on the high levels, but this approach is not recommended.

```ruby
class SomeApi::GetInfo::Endpoint < ExternalApiWrapper::BaseEndpoint
  protected

  def required_params_keys
    [:param1, :param2]
  end

  def process_raw_params(raw_params)
    ExternalApiWrapper::Data::EndpointParams.new(
      url_params: raw_params.slice(:param1),
      query_params: raw_params.slice(:param2),
      base_url: raw_params[:base_url]
    )
  end

  def endpoint_path
    '/rest/v1/get_info/{param1}'
  end

  def response_parser
    ResponseParser
  end
end

class SomeApi::GetInfo::ResponseParser
  def initialize(http_response)
    @http_response = http_response
  end

  def self.call(*opts, &block)
    new(*opts).call(&block)
  end

  def call
    # Parsing logic should be there...
  end

  private

  attr_reader :http_response
end
```

After all those steps you can reach the API endpoint by calling `SomeApi.get_info(param1: 'value1', param2: 'value2'). As you can notice, the argument list is just a hash.
But internally, each parameter could be used differently. Actually, there are 2 main roles: URL parameters and query parameters. Regarding URL parameters, please, consider the `endpoint_path` method: there is a part `{param1}`.
It looks like a placeholder! And it's true! Hence, during the call, that part will be automatically replaced by the value from the income parameter hash.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Style Checking

To be consistent around the code and its style the RuboCop is used. To run it on your local machine, please, type `rake rubocop` rake task and observe the opened page in the browser with the results.

In the repo root folder you can find the `.rubocop.yml` file, which overwrites the RuboCop default config. Those adjustments are based on my personal preferences and, of course, could be doubted :smile:

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sergio1990/external_api_wrapper.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
