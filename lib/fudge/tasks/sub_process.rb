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
    # options:
    #   environment:  a hash of environment variables to be set for
    #                 the process.  The keys are strings,
    #                 corresponding to the variables' names (case
    #                 sensitive).
    #   options:      a hash of attributes for the spawned process
    #                 (see Ruby's Process::spawn documentation for
    #                 details)
    class SubProcess < Shell
      attr_accessor :environment
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
