module Fudge
  module Models
    class Build < ActiveRecord::Base
      belongs_to :project
    end
  end
end
