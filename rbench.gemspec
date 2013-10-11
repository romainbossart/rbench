# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbench/version'

Gem::Specification.new do |spec|
  spec.name          = "rbench"
  spec.version       = Rbench::VERSION
  spec.authors       = ["Yehuda Katz & Sindre Aarsaether, and Romain Bossart"]
  spec.email         = ["romain@adomik.com"]
  spec.description   = %q{Library for generating nice ruby-benchmarks}
  spec.summary       = %q{Library for generating nice ruby-benchmarks}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
end
