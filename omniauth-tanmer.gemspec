# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-tanmer/version'

Gem::Specification.new do |gem|
  gem.name          = 'omniauth-tanmer'
  gem.version       = Omniauth::Tanmer::VERSION
  gem.authors       = ['xiaohui']
  gem.email         = ['xiaohui@tanmer.com']
  gem.description   = %q{This is the strategy for authenticating to your Tanmer service}
  gem.summary       = %q{This is the strategy for authenticating to your Tanmer service}
  gem.homepage      = 'https://gitlab.tanmer.com/tanmer/omniauth-tanmer'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.0'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'rspec-its', '~> 1.0'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end
