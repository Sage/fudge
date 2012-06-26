class Watched < ActiveRecord::Base
  self.table_name = 'watched'
  belongs_to :repo
end
