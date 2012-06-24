class Watched < ActiveRecord::Base
  set_table_name 'watched'
  belongs_to :repo
end
