# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gordon/version'

Gem::Specification.new do |spec|
  spec.name          = "gordon"
  spec.version       = Gordon::VERSION
  spec.authors       = ["Marcelo Pinheiro"]
  spec.email         = ["salizzar@gmail.com"]
  spec.description   = %q{Gordon is a tool to create OS packages using fpm-cookery and foreman, based on a lot of conventions.}
  spec.summary       = %q{A tool to create application OS packages}
  spec.homepage      = "https://github.com/salizzar/gordon"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "fpm-cookery"
  spec.add_dependency "foreman"
end
