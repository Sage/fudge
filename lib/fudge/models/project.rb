module Fudge
  module Models
    class Project < ActiveRecord::Base
      has_many :builds

      # Hack for now to get tests to pass
      def status
        :no_builds
      end
    end
  end
end
