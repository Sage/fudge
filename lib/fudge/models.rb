module Fudge
  module Models
    require 'active_record'
    ActiveRecord::Base.establish_connection Fudge::Config.database

    autoload :Build, 'fudge/models/build'
    autoload :Project, 'fudge/models/project'
  end
end
