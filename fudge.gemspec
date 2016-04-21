# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'fudge/version'

Gem::Specification.new do |s|
  s.name        = 'fudge'
  s.version     = Fudge::VERSION
  s.authors     = 'Sage One team'
  s.email       = 'support@sageone.com'
  s.homepage    = 'http://github.com/Sage/fudge'
  s.summary     = 'Fudge CI Server'
  s.description = 'Fudge Continuous Integration Server'
  s.license     = 'MIT'

  s.files         = Dir['lib/**/*']
  s.test_files    = Dir['spec/**/*.rb']
  s.executables   = %w(fudge)
  s.require_paths = %w(lib)

  s.add_dependency 'thor'
  s.add_dependency 'json'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rspec', '>= 3.0.0'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rb-fsevent' # guard dependency
  s.add_development_dependency 'yard'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'flog'
  s.add_development_dependency 'flay'
  s.add_development_dependency 'ruby2ruby'
  s.add_development_dependency 'RedCloth'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rb-inotify'
  s.add_development_dependency 'libnotify'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'cucumber'
end
