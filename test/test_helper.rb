$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'external_api_wrapper'

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/minitest'

Minitest::Reporters.use!
