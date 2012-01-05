module Fudge
  module Models
    class Project < ActiveRecord::Base
      has_many :builds, :order => :created_at

      def next_build
        last_number = builds.maximum('number') || 0
        builds.build(:number => last_number + 1)
      end

      def status
        builds.last ? builds.last.status : :no_builds
      end
    end
  end
end
