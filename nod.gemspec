# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nod/version"

Gem::Specification.new do |spec|
  spec.name          = "nod"
  spec.version       = Nod::VERSION
  spec.authors       = ["Theo Paul"]
  spec.email         = ["theo.markkus.paul@gmail.com"]

  spec.summary       = "Does good things"
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir['lib/*.rb'] + Dir['bin/*'] + Dir['lib/nod/*.rb']
  spec.bindir        = "bin"
  spec.executables   = ['nod']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "thor"
  spec.add_dependency "rubyzip"
  spec.add_dependency "nokogiri"
  spec.add_dependency "mime-types"
  spec.add_dependency "rest-client"
end
