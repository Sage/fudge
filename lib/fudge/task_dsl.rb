module Fudge
  # Domain specific language for expressing Tasks in the Fudgefile
  module TaskDSL
    extend ActiveSupport::Concern

    included do
      attr_writer :scope
    end

    # Add self to the scope
    def scope
      @scope ||= [self]
    end

    # Adds a task to the current scope
    def task(name, *args)
      klass = Fudge::Tasks.discover(name)

      task = klass.new(*args)
      current_scope.tasks << task

      with_scope(task) { yield if block_given? }
    end

    # Delegate to the current object scope
    def method_missing(meth, *args, &block)
      task meth, *args, &block
    rescue Fudge::Exceptions::TaskNotFound
      super
    end

    private
    def current_scope
      scope.last
    end

    def with_scope(task)
      scope << task
      yield
      scope.pop
    end
  end
end
