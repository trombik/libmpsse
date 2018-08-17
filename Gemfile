source 'https://rubygems.org'

# Specify your gem's dependencies in mpsse.gemspec
gemspec

# XXX use patched version of libftdi-ruby
#
# Ftdi::Context is a ManagedStruct with #release class method.
# as FFI::ManagedStruct includes Ftdi::Context, when the context object is
# outof scope, Ftdi::Context gets free()ed, which is not desired because
# libmpsse manages the Ftdi::Context. libftdi-ruby should call Ftdi.free()
# when and only when it allocates Ftdi::Context. the patched version does not
# free() Ftdi::Context if the object is created by others. without the patch,
# applications crush.
gem 'libftdi-ruby', git: 'https://github.com/trombik/libftdi-ruby.git', branch: 'mpsse'

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rubocop'
end
