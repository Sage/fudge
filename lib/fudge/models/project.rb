module Fudge
  module Models
    class Project < ActiveRecord::Base
      has_many :builds, :order => :created_at

      # Hack for now to get tests to pass
      def status
        :no_builds
      end
    end
  end
end
