# v0.3.6
* Downgrade rainbow version required to 1.1.4

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
