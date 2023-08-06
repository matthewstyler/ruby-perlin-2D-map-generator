# frozen_string_literal: true

require 'minitest/test_task'

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.warning = false
  t.test_globs = ['test/**/*_test.rb']
end

task :irb do
  exec 'irb -I lib'
end

task :lint do
  exec 'rubocop -A'
end

task :test_and_lint do
  Rake::Task['test'].invoke
  Rake::Task['lint'].invoke
end
