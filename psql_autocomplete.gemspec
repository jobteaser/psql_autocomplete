# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'psql_autocomplete/version'

Gem::Specification.new do |spec|
  spec.name          = "psql_autocomplete"
  spec.version       = PsqlAutocomplete::VERSION
  spec.authors       = ["JobTeaser"]
  spec.email         = ["mru2@users.noreply.github.com"]

  spec.summary       = %q{Allow the generation of autocomplete queries with postgres.}
  spec.description   = %q{Allow the generation of autocomplete queries with postgres.}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
