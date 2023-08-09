# frozen_string_literal: true

require 'simplecov'
require 'simplecov-json'

SimpleCov.minimum_coverage 90
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  add_filter %r{^/test/}
end

require 'minitest/autorun'
