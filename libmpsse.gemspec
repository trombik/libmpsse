lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libmpsse/version'

Gem::Specification.new do |spec|
  spec.name          = 'libmpsse'
  spec.version       = LibMpsse::VERSION
  spec.authors       = ['Stafford Brunk', 'Tomoyuki Sakurai']
  spec.email         = ['stafford.brunk@gmail.com']

  spec.summary       = 'FFI wrapper around libmpsse'
  spec.description   = 'Ruby implementation of libmpsse using FFI'
  spec.homepage      = 'https://github.com/wingrunr21/libmpsse'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi', '~> 1.9.18'
  spec.add_dependency 'libftdi-ruby', '~> 0.0.20'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
