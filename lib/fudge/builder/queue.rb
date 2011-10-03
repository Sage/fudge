module Fudge
  module Builder
    class Queue
      attr_accessor :queue

      def initialize
        self.queue = []
        @_stopping = false
      end

      def <<(build)
        queue << build
      end

      def next
        queue.shift
      end

      def poll
        puts "Cheking for queued builds..."
        build = self.next
        if build
          puts "Building #{build.project.name} ##{build.number}" if build
          build.status = :started
          build.save!
          build.build!
          puts "Built."
        else
          puts "No builds queued"
        end
      end

      def start!
        until stopping?
          poll
          sleep 10
        end
      end

      def stopping?
        @_stopping
      end

      def stop!
        @_stopping = true
      end
    end
  end
end
