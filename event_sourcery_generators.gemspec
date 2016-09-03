# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'event_sourcery/version'

Gem::Specification.new do |spec|
  spec.name = 'event_sourcery_generators'
  spec.version = EventSourcery::VERSION
  spec.authors = ['Sebastian von Conrad']
  spec.email = ['sebastian.von.conrad@envato.com']

  spec.summary       = %q{Generators for EventSourcery}
  spec.description   = %q{}
  spec.homepage      = ''

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'sequel'
  spec.add_dependency 'pg'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.2'
  spec.add_development_dependency 'rspec'
end
