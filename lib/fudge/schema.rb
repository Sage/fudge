require 'benchmark'
require 'active_record'

ActiveRecord::Schema.define(:version => 1) do
  create_table "projects", :force => true do |t|
    t.string   "name"
  end

  create_table "builds", :force => true do |t|
    t.string   "name"
    t.integer "project_id"
  end
end
