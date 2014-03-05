# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "sendregning/version"

Gem::Specification.new do |s|
  s.name        = 'sendregning'
  s.version     = Sendregning::VERSION
  s.date        = '2014-03-05'
  s.summary     = "Ruby client for the SendRegning Web Service"
  s.description = "Ruby client for the SendRegning Web Service"
  s.authors     = ["Inge Jørgensen"]
  s.email       = 'inge@manualdesign.no'
  s.homepage    = 'http://github.com/elektronaut/sendregning'
  s.license     = 'MIT'
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'httparty',       '>= 0.6.1'
  s.add_runtime_dependency 'builder',        '>= 2.1.2'
  s.add_runtime_dependency 'multipart-post', '>= 1.0.1'
end
