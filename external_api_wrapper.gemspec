
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "external_api_wrapper/version"

Gem::Specification.new do |spec|
  spec.name          = "external_api_wrapper"
  spec.version       = ExternalApiWrapper::VERSION
  spec.authors       = ["Sergio Gernyak"]
  spec.email         = ["sergeg1990@gmail.com"]

  spec.summary       = %q{Abstraction to easily create wrappers around 3-rd party API}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/sergio1990/external_api_wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
