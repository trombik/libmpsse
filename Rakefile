require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :rubocop do
  sh 'rubocop'
end

task :yard do
  sh "bundle exec yardoc --fail-on-warning 'lib/**/*.rb'"
end

task default: %i[spec rubocop yard]
