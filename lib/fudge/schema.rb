require 'benchmark'
require 'active_record'

ActiveRecord::Schema.define(:version => 1) do
  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "repository"
  end

  create_table "builds", :force => true do |t|
    t.integer  'project_id'

    t.string   'sha'
    t.string   'author'
    t.string   'committer'
    t.integer  'number'

    t.string   'branch'
    t.string   'status'
    t.text     'diff'
    t.text     'output'

    t.datetime 'created_at'
  end
end
