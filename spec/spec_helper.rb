require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end

require 'rspec'
require 'fudge'
require 'fudge/rspec/matchers'

Dir[File.expand_path('../../spec/support/*', __FILE__)].each { |f| require f }

# Get rid of output in specs
RSpec.configure do |c|
  c.around :each do |example|
    hide_stdout do
      example.run
    end
  end
end
