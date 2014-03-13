# # -*- encoding : utf-8 -*-

require 'shellwords'

module Fudge
  module Tasks
    # Allow use of shell commands as tasks.
    #
    # Unlike Fudge::Shell, this task will not spawn a new shell.
    #
    # Allows the caller to set environment variables for the process,
    # and to specify process attributes, as with Process::Spawn.
    #
    # The constructor and {#run #run} method each accept two new
    # options, {#environment :environment} and {#spawn_options
    # :spawn_options}.
    class SubProcess < Shell
      # @!attribute environment
      #   @return [Hash] environment variables to be set for the
      #                  process; the keys are strings, corresponding
      #                  to the variables' names (case sensitive).
      attr_accessor :environment
      # @!attribute spawn_options
      #   @return [Hash] attributes for the spawned process (see
      #                  Ruby's Process::spawn documentation for
      #                  details)
      attr_accessor :spawn_options

      private

      # Defines the command to run
      def cmd(options={})
        env = merge_option(:environment, options)
        spawn_options = merge_option(:spawn_options, options)
        mk_cmd(env, arguments, spawn_options)
      end

      # Merges the option hash set when the task was create with that
      # passed in on this run.
      def merge_option(key, options)
        my_options = self.send(key) || {}
        my_options.merge(options[key] || {})
      end

      # Make the command for IO::popen, by splitting the command line
      # into an array and adding the environment variables and spawn options.
      def mk_cmd(env, cmd, options)
        [env, cmd.shellsplit, options].flatten
      end
    end

    register SubProcess
  end
end
