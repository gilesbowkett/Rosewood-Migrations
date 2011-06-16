# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rosewood_migrations/version"

Gem::Specification.new do |s|
  s.name        = "rosewood_migrations"
  s.version     = RosewoodMigrations::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Giles Bowkett"]
  s.email       = ["gilesb@gmail.com"]
  s.homepage    = "http://www.youtube.com/watch?v=G_pGT8Q_tjk"
  s.summary     = %q{Pardon me. Do you have any Grey Poupon?}
  s.description = %q{Smooth, uninterrupted comfort.}

  s.rubyforge_project = "rosewood_migrations"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

