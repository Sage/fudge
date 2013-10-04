# Fudge
[![travis-ci](https://secure.travis-ci.org/Sage/fudge.png)](http://travis-ci.org/#!/Sage/fudge)
[![Dependency Status](https://gemnasium.com/Sage/fudge.png)](https://gemnasium.com/Sage/fudge)
[![Code Climate](https://codeclimate.com/github/Sage/fudge.png)](https://codeclimate.com/github/Sage/fudge)
[![Gem Version](https://badge.fury.io/rb/fudge.png)](http://badge.fury.io/rb/fudge)

## Description

Fudge is a CI build tool for Ruby/Rails projects.

### Features

* Define your CI build process in a Ruby DSL.
* Keep your build definition in your code repository and version control.
* Define different build processes for different branches of your code.
* Run common tasks including code coverage assertion.
* Define custom tasks for your build process.

## Installation

Add to your project's Gemfile:

```ruby
gem 'fudge'
```

Run in your project root:

```
bundle install
```

## Usage

To create a blank Fudgefile, run in your project root:

```
bundle exec fudge init
```

To run the CI build (this is what you'd put in your CI server):

```
bundle exec fudge build
```

This will run the build named 'default'.  To run a specific build in the Fudgefile:

```
bundle exec fudge build the_build_name
```

### Fudgefile syntax

To define a build with a given name (or for a given branch):

```ruby
build :some_name do
end
```

To define some tasks on that build:

```ruby
build :some_name do
  task :rspec, :coverage => 100
end
```

Any options passed to the task method will be passed to the task's initializer.

You can also use one of the alternative method missing syntax:

```ruby
build :some_name do |b|
  rspec :coverage => 100
end
```

### Composite Tasks

Some tasks are composite tasks, and can have tasks added to themselves, for example the each_directory task:

```ruby
build :some_name do
  task :each_directory, '*' do
    task :rspec
  end
end
```

### Task Groups

You can define task groups to be reused later on in your Fudgefile. For example:

```ruby
task_group :tests do
  rspec
end

task_group :docs do
  yard
end

task_group :quality do
  cane
end

build :some_name do
  task_group :tests
  task_group :docs
  task_group :quality
end

build :nodoc do
  task_group :tests
end
```

Task groups can take arguments, so you can make conditional task groups for sharing between build. For example:

```ruby
task_group :deploy do |to|
  shell "cp -r site/ #{to}"
end

build :default do
  task_group :deploy, '/var/www/dev'
end

build :production do
  task_group :deploy, '/var/www/live'
end
```

### Callbacks

You can define success and failure callbacks using the following syntax:

```ruby
build :default do
  rspec

  on_success do
    shell 'deploy.sh'
  end

  on_failure do
    shell 'send_errors.sh'
  end
end
```

Build will by default run *without* callbacks enabled. To run a build with callbacks, run:

```
bundle exec fudge build --callbacks
```

You can mix task groups with callbacks however you like, for example:

```ruby
task_group :deploy do
  shell 'deploy.sh'
end

task_group :error_callbacks do
  on_failure do
    shell 'send_errors.sh'
  end
end

build :default do
  on_success do
    task_group :deploy
  end

  task_group :error_callbacks
end
```

### Built-in tasks
Fudge supports several tasks by default. Most of them depend on a gem which also must be included in your project's `Gemfile` (or with `add_development_dependency` in your gem's `.gemspec`).

#### brakeman
Run the [Brakeman](http://brakemanscanner.org/) Rails security scanner.
```
    task :brakeman
```
will fail if any security warnings are encountered.
```
    task :brakeman, :max => 2
```
will allow a maximum of two known security issues to get through.
#### cane
Checks code style using the [cane](https://github.com/square/cane) gem.  This can be run over the entire tree or in the enclosing subdirectory (`each_directory` or `in_directory`). Options can be set in the `.cane` file, but for convenience the `max_width` option can be used to easily override the default line width of 80.
```
  cane :max_width => 120
```

#### clean_bundler_env
Ensures that the code block runs in a clean [Bundler](http://bundler.io/) environment.
#### each_directory
Run the resulting block in each directory (see examples above).
```
  each_directory 'meta_*', :exclude => ['meta_useless', 'meta_broken'] do
    ...
  end
```
#### rake
Run a `rake` command, requiring that it return success.
#### shell
Run a generic shell command, requiring that it return success.
#### flay
Code duplication is detected by [Flay](http://sadi.st/Flay.html).  See examples below.
#### flog
[Flog](http://sadi.st/Flog.html) calculates code complexity using an ABC metric and allows for maximum individual values and maximum average values.  This can be used to ensure that you are alerted quickly when new complex code is added to your project.  See examples below.
#### in_directory
Run the resulting block in a specific directory (as with `each_directory`).
#### rspec
Run `rspec`, enforcing minimum `:coverage` as a percent (using [simplecov](https://github.com/colszowka/simplecov)). See examples above.
#### yard
Runs [YARD](http://yardoc.org/) to ensure documentation coverage.
```
  yard 'stats --list-undoc', :coverage => 100
```
will require 100% coverage, and show all code that is not documented.

### Defining tasks

A task is a class that responds to two methods:

 * `self.name` - A class method that returns a symbol representing the task. This is what will be used to identify your task in the Fudgefile. If not defined, it will be derived from the class name (e.g. in below example, it will be `:loud_task`).
 * `run` - An instance method which carries out the contents of the task. Should return `true` or `false` depending on whether the task succeeded.

For example, here is a simple task which will print some output and always pass:

```ruby
class LoudTask < Fudge::Tasks::Task
  def self.name
    :loud
  end

  def run
    puts "I WAS RUN"

    true
  end
end
```

### Registering your task

To make your task available to Fudge, you simply register it in `Fudge::Tasks`:

```ruby
require 'fudge'

Fudge::Tasks.register(LoudTask)
```

This will make the `LoudTask` task available in your Fudgefile's like so:

```ruby
build :some_name do
  task :loud
end
```

### Extending the Shell task

Many tasks simply run a shell command and may accept some extra configuration options. To define a task of this kind, you can sublcass `Shell` and simply define the `cmd` method:

```ruby
class LsTask < Fudge::Tasks::Shell
  def cmd
    "ls #{arguments}"
  end
end
```

The `arguments` method is provided by the `Shell` base class and will be a string of all other positional arguments passed to the task. For example:

```ruby
build :default do
  task :ls, '-l', '-a'
end
```

would run the command `ls -l -a`.

You can take hash-like options, which will automatically be set if you have an attribute with the same name. For example:

```ruby
class LsTask < Fudge::Tasks::Shell
  attr_accessor :all

  def cmd
    arguments << ' -a' if all
    "ls #{arguments}"
  end
end
```

Now this task can be used like so:

```ruby
build :default do
  task :ls, :all => true
end
```

### Checking output with the Shell task

You can define that some output from a command is required by responding to `check_for` with a regexp. For example:

```ruby
class LsTask < Fudge::Tasks::Shell
  def cmd
    "ls #{arguments}"
  end

  def check_for
    /4 files found/
  end
end
```

The above task will only pass if the output contains "4 files found".

If you want to do some further processing on the contents matched by the regexp, you can provide an array with the second element being a lambda, which wil be called to process the output:

```ruby
class LsTask < Fudge::Tasks::Shell
  def cmd
    "ls #{arguments}"
  end

  def check_for
    [/(\d+) files found/, lambda { |n| n.to_i >= 4 }]
  end
end
```

The above task will only pass if the output contains "n files found", where n is a number, and also n is at least 4.

### Defining composite tasks

Some tasks may require you to run a number of commands one after the other. You can hook into other fudge tasks by including the Fudge DSL into your composite task:

```ruby
class DeployTask < Fudge::Tasks::CompositeTask
  include Fudge::TaskDSL

  def self.name
    :deploy
  end

  def initialize(*args)
    super

    task :shell, 'build_docs.sh'
    task :shell, 'cp -r docs/ /var/ww/deploy/docs'
  end
end
Fudge::Tasks.register(DeployTask)
```

The above will run the given tasks in the order defined, and only pass if both tasks pass. It can then be used in a FudgeFile like so:

```ruby
build :default do
  task :deploy
end
```

### Setting per-directory options for tasks

Sometimes you'll want different options to be used for specific subdirectories.  This is especially useful with code metric tools.

Instead of having all of these values listed explicitly in your Fudgefile you can instead place them in a `fudge_settings.yml` file in each subdirectory.

So instead of this in your `Fudgefile`...
```ruby
  in_directory 'meta_addresses' do
    task :flay, :exclude => '^\.\/(db|factories|spec)\/'
    task :flog, :exclude => '^\.\/(db|factories|spec)\/', :max => 20, :average => 5, :methods => true
  end
  in_directory 'meta_banks' do
    task :flay, :exclude => '^\.\/(db|factories|spec)\/', :max => 172
    task :flog, :exclude => '^\.\/(db|factories|spec)\/', :max => 74.9, :average => 9.1, :methods => true
  end
```
you can just have this:
```ruby
  each_directory 'meta_*' do
    task :flay, :exclude => '^\.\/(db|factories|spec)\/'
    task :flog, :exclude => '^\.\/(db|factories|spec)\/', :methods => true
  end
```
and this in your `meta_addresses/fudge_settings.yml`:
```
flog:
  max: 20
  average: 5
```
and this in your `meta_banks/fudge_settings.yml`:
```
flay:
  max: 172
flog:
  max: 74.9 
  average: 9.1
```
You can set the default values in your `Fudgefile` and override them only as necessary in specific subdiretories.
