# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fudge/version"

Gem::Specification.new do |s|
  s.name        = "fudge"
  s.version     = Fudge::VERSION
  s.authors     = ["Steven Anderson"]
  s.email       = ["steve@whilefalse.net"]
  s.homepage    = ""
  s.summary     = %q{Fudge CI Server}
  s.description = %q{Fudge CI Server}

  s.rubyforge_project = "fudge"

  s.files         = Dir['lib/**/*.rb']
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'git'
  s.add_dependency 'sinatra'
  s.add_dependency 'haml'
  s.add_dependency 'thor'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'fakefs'
end
