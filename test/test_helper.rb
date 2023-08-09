# frozen_string_literal: true

require 'simplecov'

SimpleCov.minimum_coverage 90
SimpleCov.start do
  add_filter %r{^/test/}
end

require 'minitest/autorun'
