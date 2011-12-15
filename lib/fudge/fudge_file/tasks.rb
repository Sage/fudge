module Fudge
  module FudgeFile
    module Tasks
      autoload :CompositeTask, 'fudge/fudge_file/tasks/composite_task'
      autoload :EachDirectory, 'fudge/fudge_file/tasks/each_directory'
      autoload :InDirectory, 'fudge/fudge_file/tasks/in_directory'
      autoload :Rake, 'fudge/fudge_file/tasks/rake'
      autoload :Rspec, 'fudge/fudge_file/tasks/rspec'
      autoload :Yard, 'fudge/fudge_file/tasks/yard'
    end
  end
end
