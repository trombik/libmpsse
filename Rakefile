require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :rubocop do
  sh 'rubocop'
end

task :yard do
  sh 'yard'
end

task default: %i[spec rubocop yard]
