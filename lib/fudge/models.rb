require 'active_record'

module Fudge
  module Models
    autoload :Build, 'fudge/models/build'
    autoload :Branch, 'fudge/models/branch'
    autoload :Project, 'fudge/models/project'

    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.establish_connection(Fudge::Config.database)
    end
  end
end
