# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "sendregning/version"

Gem::Specification.new do |s|
  s.name        = "sendregning"
  s.version     = Sendregning::VERSION
  s.summary     = "Ruby client for the SendRegning Web Service"
  s.description = "Ruby client for the SendRegning Web Service"
  s.authors     = ["Inge Jørgensen"]
  s.email       = "inge@elektronaut.no"
  s.homepage    = "https://github.com/elektronaut/sendregning"
  s.license     = "MIT"
  s.required_ruby_version = ">= 2.7.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ["lib"]

  s.add_runtime_dependency "builder",        "~> 3.1"
  s.add_runtime_dependency "httmultiparty",  "~> 0.3"
  s.add_runtime_dependency "httparty",       "~> 0.13"

  s.add_development_dependency "rake"
end
