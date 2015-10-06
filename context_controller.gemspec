# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'context_controller/version'

Gem::Specification.new do |spec|
  spec.name          = "context_controller"
  spec.version       = ContextController::VERSION
  spec.authors       = ["Steve Chung"]
  spec.email         = ["hello@stevenchung.ca"]

  spec.summary       = "Rails Controllers, but general purpose."
  spec.homepage      = "https://github.com/FinalCAD/context_controller"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
end
