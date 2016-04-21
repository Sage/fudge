require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :fudge

# Test Fudge using Fudge
task :fudge do
  exec 'fudge build 2> /dev/null'
end
