# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-mytail"
  spec.version       = "0.0.1"
  spec.authors       = ["ishioka"]
  spec.email         = ["ishioka@iij.ad.jp"]
  spec.summary       = %q{mytail.}
  spec.description   = %q{mytail.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "fluentd"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "fluentd" #TODO
end
