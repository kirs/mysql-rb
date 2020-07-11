require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run tests"
task default: [:test]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = Dir.glob('test/**/*_test.rb')
end
