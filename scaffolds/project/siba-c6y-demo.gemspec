# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "siba-c6y-demo/version"

Gem::Specification.new do |s|
  s.name        = "siba-c6y-demo"
  s.version     = Siba::C6y::Demo::VERSION
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TOD0: your@email.com"]
  s.homepage    = ""
  s.license     = "MIT"
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency     'siba', '~>siba_version'

  s.add_development_dependency  'minitest', '~>4.7'
  s.add_development_dependency  'rake', '~>10.0'
  s.add_development_dependency  'guard-minitest', '~>0.5'
end
