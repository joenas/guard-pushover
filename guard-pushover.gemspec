# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/pushover'

Gem::Specification.new do |spec|
  spec.name          = "guard-pushover"
  spec.version       = Guard::Pushover::VERSION
  spec.authors       = ["Jon Neverland"]
  spec.email         = ["jonwestin@gmail.com"]
  spec.description   = %q{Have Guard sending Pushover notifications}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rushover"
  spec.add_runtime_dependency "guard"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-pushover"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-shell"
  spec.add_development_dependency "rspec"
end
