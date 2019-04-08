# v0.6.4
* Add support for brakeman 4.5.0 output

# v0.6.3
* Add cucumber coverage check
* Rubocop improvements

# v0.6.2
* Add cucumber support.

# v0.6.1
* Remove dependency on activesupport.

# v0.6.0
* Add `--time` option to `build` command, which prints out time spent for the build. [#97](https://github.com/Sage/fudge/pull/97).
* Update fudge task matchers to support RSpec versions 2 and 3.
* Update RSpec development dependency to version 3.

# v0.5.0
* Add `list` command to CLI, which outputs a list of builds defined in the Fudgefile.

# v0.4.1
* Fix problem with YAML in activesupport 4.1.0 [#92](https://github.com/Sage/fudge/pull/92)

# v0.4.0
* Reworked output processing [#89](https://github.com/Sage/fudge/pull/89)
* Removed rainbow dependency [#90](https://github.com/Sage/fudge/pull/90)
* Update gems for release 0.4.0 [#91](https://github.com/Sage/fudge/pull/91)
* New projects can use Yard without errors [#74](https://github.com/Sage/fudge/issues/74)

# v0.3.8
* Add SubProcess task, a task to run shell commands with more control over the command environment and execution than Shell provides.

# v0.3.7
* Fix argument handling in tasks [#85](https://github.com/Sage/fudge/pull/85) fixes [#84](https://github.com/Sage/fudge/issues/84)

# v0.3.6
* Downgrade rainbow version required to 1.1.4 to address [#77](https://github.com/Sage/fudge/pull/77) in the short term. [#82](https://github.com/Sage/fudge/pull/82)

# v0.3.5
* Remove rubyforge references, clean up gemfile/gemspec, bump version [#79](https://github.com/Sage/fudge/pull/79)
* Fix deprecation of `mock` in rspec. [#80](https://github.com/Sage/fudge/pull/80)
* Fix GREP_OPTIONS color bug [#81](https://github.com/Sage/fudge/pull/81)

# v0.3.4
* Fix rainbow requirement for strings [#78](https://github.com/Sage/fudge/pull/78)

# v0.3.3
* Fixed rspec bug for no tests [#75](https://github.com/Sage/fudge/issues/75)

# v0.3.2
* Fix license in gemspec [#72](https://github.com/Sage/fudge/issues/72)

# v0.3.1
* Fixed rspec bug for passing tests in multiples of 10 without code coverage [#70](https://github.com/Sage/fudge/issues/70)

# v0.3.0
* Add Brakeman support [#68](https://github.com/Sage/fudge/pull/68)

# v0.2.3
* Fix directory settings so they work for coverage [#66](https://github.com/Sage/fudge/pull/66)

# v0.2.2
* Made the default encoding Encoding::UTF_8 to solve issues with regex match of the console output

# v0.2.1
* Updated json dependency from ~>1.7.7 to ~>1.8.0

# v0.2.0
* Load fudge_settings.yml in each working directory to modify options for the task being processed. [#61](https://github.com/Sage/fudge/issues/61)

# v0.1.2
* Add support for complex regex. [#59](https://github.com/Sage/fudge/issues/59)

# v0.1.1
* Add support for perfect Flog scores.

# v0.1.0
* Refactoring for [cleanup](https://github.com/Sage/fudge/pull/53)
* Support for [flog and flay](https://github.com/Sage/fudge/pull/51)
* Refactoring of [output](https://github.com/Sage/fudge/pull/55) [streams](https://github.com/Sage/fudge/pull/50)
* Use bundler implementation for [clean_bundler_env](https://github.com/Sage/fudge/pull/44)
