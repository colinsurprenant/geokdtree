# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geokdtree/version'

Gem::Specification.new do |gem|
  gem.name          = "geokdtree"
  gem.version       = Geokdtree::VERSION
  gem.authors       = ["Colin Surprenant"]
  gem.email         = ["colin.surprenant@gmail.com"]
  gem.description   = "Ruby & JRuby gem with a fast k-d tree C implementation using FFI bindings with support for latitude/longitude and geo distance range search"
  gem.summary       = "Ruby & JRuby FFI gem with a fast k-d tree C implementation with geo support"
  gem.homepage      = "http://github.com/colinsurprenant/geokdtree"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_runtime_dependency "ffi"
end
