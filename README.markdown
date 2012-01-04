# Fudge - Rails/Git based CI server and build tool.

Fudge is a Rails/Git based CI server and build tool.

## Features

* Defining build processs and success criteria based on a FudgeFile.
* Abiility to run the build process through 'fudge build' command.

### Coming Features

* Ability to define different builds and run them specificly.
* Run a CI server for a project, which picks up git changes and runs a build.
* Automatic building of new branches in Git.
* Specifying builds for specific branches, and build them based on the current branch.

## Installation

Add to your project's Gemfile:

    gem 'fudge', :git => 'git@github.com:Sage/fudge.git'

Run in your project root:

    bundle install

## Usage

To create a blank Fudgefile, run in your project root:


    bundle exec fudge init

To run the default build:

    bundle exec fudge build

## Fudgefile syntax

To define a build with a given name:


    build :some_name do |b|
    end

To define some tasks on that build:

    build :some_name do |b|
      b.task :rspec
    end

Any options passed to the task method will be passed to the task's initializer.

### Composite Tasks

Some tasks are composite tasks, and can have tasks added to themselves, for example the each_directory task:

    build :some_name do |b|
      b.task :each_directory, '*' do |t|
        t.task :rspec
      end
    end

## Defining tasks

A task is a class that responds to two methods:

@self.name@ => A class method that returns a symbol representing the task. This is what will be used to identify your task in the Fudgefile.
@run@ => An instance method which carries out the contents of the task. Should return @true@ or @false@ depending on whether the task succeeded.

For example, here is a simple task which will print some output and always pass:

    class LoudTask
      def self.name
        :loud
      end

      def run
        puts "I WAS RUN"
        true
      end
    end

### Registering your task

To make your task available to Fudge, you simply register it in the @TaskRegistry@:

    require 'fudge'
    Fudge::FudgeFile::TaskRegistry.register(LoudTask)

This will make the @LoudTask@ task available in your Fudgefile's like so:

    build :some_name do |b|
      b.task :loud
    end
