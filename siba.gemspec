# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "siba/version"

Gem::Specification.new do |s|
  s.name        = "siba"
  s.version     = Siba::VERSION
  s.authors     = ["Evgeny Neumerzhitskiy"]
  s.email       = ["sausageskin@gmail.com"]
  s.homepage    = "https://github.com/evgenyneu/siba"
  s.license     = "MIT"
  s.summary     = %q{Simple backup and restore utility.}
  s.description = %q{SIBA is a backup and restore utility. It implements daily backup rotation scheme. It retains full year history of backups by keeping 23 files in total: for the last 6 days, 5 weeks and 12 months. Backups are archived and encrypted. Various backup sources and destinations can be added through extension gems.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_rubygems_version = '>=1.9.0'

  s.add_development_dependency 'minitest', '~>4.7'
  s.add_development_dependency 'rake', '~>10.0'
  s.add_development_dependency 'guard-minitest', '~>0.5'

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
