options = {
  cmd: "clear && bundle exec rspec spec/ --no-profile --order defined --fail-fast",
  all_after_pass: false,
  all_on_start: false,
  failed_mode: :focus
}

guard :rspec, options do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)
  watch(%r{^lib/(.+)\.rb}) { rspec.spec_dir }
end
