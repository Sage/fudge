task(:environment) do
  require File.expand_path('../config/application.rb', __FILE__)
end

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end

task :default => :fudge

# Test Fudge using Fudge
task :fudge do
  exec 'fudge build 2> /dev/null'
end
