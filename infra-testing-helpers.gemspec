# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "infra-testing-helpers"
  spec.version       = '0.0.1'
  spec.authors       = ["Ryan Doyle"]
  spec.email         = ["ryan@doylenet.net"]
  spec.summary       = %q{Integrations with RSpec, Puppet and Vagrant to help infrastructure testing}
  spec.description   = %q{RSpec helper functions to run Puppet code as part of Serverspec tests}
  spec.homepage      = "https://github.com/ryandoyle/infra-testing-helpers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", '~> 3'

  spec.add_development_dependency "serverspec", '~> 2'
  spec.add_development_dependency "rake", '~> 10'

end
