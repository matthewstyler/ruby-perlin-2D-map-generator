# frozen_string_literal: true

require 'minitest/test_task'

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.warning = false
  t.test_globs = ['test/**/*_test.rb']
end

task :irb do
  exec 'irb -I lib -r ./lib/**/*'
end

task :lint do
  exec 'rubocop -A'
end
