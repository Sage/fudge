# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fudge/version"

Gem::Specification.new do |s|
  s.name        = "fudge"
  s.version     = Fudge::VERSION
  s.authors     = %q{Steven Anderson}
  s.email       = %q{steve@whilefalse.net}
  s.homepage    = %q{http://github.com/Sage/fudge}
  s.summary     = %q{Fudge CI Server}
  s.description = %q{Fudge CI Server}

  s.rubyforge_project = "fudge"

  s.files         = Dir['lib/**/*']
  s.test_files    = Dir['spec/**/*.rb']
  s.executables   = %w{fudge}
  s.require_paths = %w{lib}

  s.add_dependency 'git'
  s.add_dependency 'sinatra'
  s.add_dependency 'haml'
  s.add_dependency 'thor'
  s.add_dependency 'rainbow'
  s.add_dependency 'activerecord'
  s.add_dependency 'sqlite3'
  s.add_dependency 'thor'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec', '>= 2.6'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'pry'
  # s.add_development_dependency 'simplecov'
end
