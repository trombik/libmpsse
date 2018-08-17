source 'https://rubygems.org'

# Specify your gem's dependencies in mpsse.gemspec
gemspec

gem 'libftdi-ruby', :git => '/usr/home/trombik/github/trombik/e_compornets/e-example-FT2232/ruby/libftdi-ruby', :branch => 'mpsse'

group :development do
  gem 'pry'
  gem 'pry-byebug'
  gem 'guard'
  gem 'guard-rspec'
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /(?i-mx:bsd|dragonfly)/
    gem 'rb-kqueue', '>= 0.2'
  end
end
