require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end

require 'rspec'
require 'fudge'
require 'haml'
require 'fakefs/safe'

Dir[File.expand_path('../../spec/support/*', __FILE__)].each { |f| require f }

# Get rid of output in specs
RSpec.configure do |c|
  c.before :each do
    $stdout = StringIO.new
  end
end
