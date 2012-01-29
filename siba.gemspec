# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "siba/version"

Gem::Specification.new do |s|
  s.name        = "siba"
  s.version     = Siba::VERSION
  s.authors     = ["Evgeny Neumerzhitskiy"]
  s.email       = ["sausageskin@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Simple backup and restore utility.}
  s.description = %q{This is a backup and restore utility. SIBA implements backup rotation scheme. It retains a one year history of backups by keeping up to 23 files: 6 daily, 5 weekly and 12 monthly backups. Backups are compressed and encrypted. Various backup sources and destinations can be added through extension gems.}

  s.rubyforge_project = "siba"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_rubygems_version = '~>1.8'

  s.add_development_dependency 'minitest', '~>2.10'
  s.add_development_dependency 'rake', '~>0.9'
  s.add_development_dependency 'guard-minitest', '~>0.4'

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
